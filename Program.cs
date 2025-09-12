using System.Text;
using System.Text.RegularExpressions;
using Microsoft.Data.SqlClient;
using Dapper;
using Npgsql;

namespace Migration
{
    public class Migration(string sqlServerConn, string sqlServerConnCmn, string pgConn)
    {
        private readonly string _sqlServerConn = sqlServerConn;
        private readonly string _sqlServerConnCmn = sqlServerConnCmn;
        private readonly string _pgConn = pgConn;

        private record TablePair(string SqlTable, string PgTable, string OrderByColumn);

        private static string ToSnakeCase(string input)
        {
            if (string.IsNullOrEmpty(input))
                return input;

            var knownTokens = new[] {
                "id", "key", "type", "ds", "system", "message", "source", "audit"
            };
            
            bool isAllLower = input.All(char.IsLower);
            if (isAllLower)
            {
                foreach (var token in knownTokens)
                {
                    input = Regex.Replace(input, token, $"_{token}", RegexOptions.IgnoreCase);
                }
                input = input.TrimStart('_');
            }

            var sb = new StringBuilder();
            for (int i = 0; i < input.Length; i++)
            {
                char c = input[i];

                if (char.IsUpper(c))
                {
                    if (i > 0 &&
                        (char.IsLower(input[i - 1]) ||
                         (i + 1 < input.Length && char.IsLower(input[i + 1]))))
                    {
                        sb.Append('_');
                    }

                    sb.Append(char.ToLowerInvariant(c));
                }
                else
                {
                    sb.Append(c);
                }
            }

            return sb.ToString();
        }

        public async Task CompareTablesAsync()
        {
            var tablePairs = new List<TablePair>
            {
                new("APIServiceCatalog", "api_service_catalog", "ServiceCatalogKey"),
                new("APIServiceContract", "api_service_contract", "ServiceContractKey"),
                new("ApplicationLog", "application_log", "LogItemKey"),
                new("AttachmentLog", "attachment_log", "AttachItemKey"),
                new("HtmlBodyLog", "html_body_log", "HtmlItemKey"),
                new("ParmGridLog", "parmgrid_log", "ParmItemKey"),
                new("PostAddressLog", "post_address_log", "PostItemKey"),
                new("SendGridEventDetails", "sendgrid_event_details", "eventDetailKey"),
                new("SendGridEvents", "sendgrid_events", "eventKey"),
                new("SendGridLog", "sendgrid_log", "EmailItemKey"),
                new("SendGridMessages", "sendgrid_messages", "msgKey"),
                new("SendGridTemplate", "sendgrid_template", "EmailTemplateKey")
            };

            var tableCmnPairs = new List<TablePair>
            {
                new("AuditRequest", "audit_request", "AuditKey")
            };
            
            await CompareTablesSubAsync(tablePairs, _sqlServerConn, _pgConn);
            await CompareTablesSubAsync(tableCmnPairs, _sqlServerConnCmn, _pgConn);
         }

        private async Task CompareTablesSubAsync(List<TablePair> tablePairs, string sqlCxn, string pSqlCxn)
        {
            await using var sqlConn = new SqlConnection(sqlCxn);
            await using var pgConn = new NpgsqlConnection(pSqlCxn);

            await sqlConn.OpenAsync();
            await pgConn.OpenAsync();

            foreach (var pair in tablePairs)
            {
                Console.WriteLine($"\n🔍 Comparing {pair.SqlTable} ↔ {pair.PgTable}");
                var sqlData = await sqlConn.QueryAsync<dynamic>(
                    $"SELECT * FROM {pair.SqlTable} ORDER BY {pair.OrderByColumn}");

                var pgData = await pgConn.QueryAsync<dynamic>(
                    $"SELECT * FROM {pair.PgTable} ORDER BY {ToSnakeCase(pair.OrderByColumn)}");

                var sqlList = sqlData.ToList();
                var pgList = pgData.ToList();

                if (sqlList.Count != pgList.Count)
                {
                    Console.WriteLine($"Row count mismatch: SQL Server={sqlList.Count}, PostgreSQL={pgList.Count}");
                }

                int maxRows = Math.Max(sqlList.Count, pgList.Count);

                for (int i = 0; i < maxRows; i++)
                {
                    if (i >= sqlList.Count)
                    {
                        Console.WriteLine($"Extra row in PostgreSQL at row {i + 1}:");
                        //Console.WriteLine(pgList[i]);
                        DumpRow(pgList[i]);
                        continue;
                    }
                    
                    if (i >= pgList.Count)
                    {
                        Console.WriteLine($"Extra row in SQL Server at row {i + 1}:");
                        //Console.WriteLine(sqlList[i]);
                        DumpRow(sqlList[i]);
                        continue;
                    }
                    
                    var sqlRow = (IDictionary<string, object>) sqlList[i];
                    var pgRow = (IDictionary<string, object>) pgList[i];

                    foreach (var prop in sqlRow.Keys)
                    {
                        var sqlValue = sqlRow[prop];
                        var pgKey = ToSnakeCase(prop);

                        if (!pgRow.TryGetValue(pgKey, out var pgValue))
                        {
                            Console.WriteLine($"Row {i + 1}: PostgreSQL column '{pgKey}' not found.");
                            continue;
                        }

                        if (sqlValue is DateTime sqlDt && pgValue is DateTime pgDt)
                        {
                            var sqlTrunc = sqlDt.AddTicks(-(sqlDt.Ticks % TimeSpan.TicksPerSecond));
                            var pgTrunc = pgDt.AddTicks(-(pgDt.Ticks % TimeSpan.TicksPerSecond));

                            if (sqlTrunc != pgTrunc)
                            {
                                Console.WriteLine($"Row {i}, column '{pgKey}': TIMESTAMP mismatch → SQL = {sqlTrunc}, PG = {pgTrunc}");
                            }
                        }
                        else if (!Equals(Normalize(sqlValue), Normalize(pgValue)))
                        {
                            Console.WriteLine($"Mismatch in row {i + 1}, column {prop} / {pgKey}:");
                            Console.WriteLine($"SQL Server: {sqlValue}");
                            Console.WriteLine($"PostgreSQL: {pgValue}");
                        }
                    }
                }
            }
        }

        void DumpRow(object rowObj)
        {
            var row = (IDictionary<string, object>)rowObj;
            foreach (var kvp in row)
            {
                Console.WriteLine($"  {kvp.Key}: {kvp.Value}");
            }
        }

        object? Normalize(object value) =>
            value is DBNull ? null : value;
    }

    class Program
    {
        static async Task Main()
        {
            var comparer = new Migration(
                "Server=.;Database=Insights;Trusted_Connection=True;trustServerCertificate=true;",
                "Server=.;Database=IntegrationCommon;Trusted_Connection=True;trustServerCertificate=true;",
                "Host=localhost;Port=5432;Database=insights;Username=slemkau;Password=Uakmels!1!2"
            );

            await comparer.CompareTablesAsync();
        }
    }
}