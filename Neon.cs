using Dapper;
using Npgsql;

namespace Migration
{
    public class Postgres(string pgConn, string pgConn2)
    {
        private readonly string _pgConn = pgConn;
        private readonly string _pgConn2 = pgConn2;

        private record TablePair(string PgTable, string OrderByColumn);

        public async Task CompareTablesAsync()
        {
            var tablePairs = new List<TablePair>
            {
                new("api_service_catalog", "service_catalog_key"),
                new("api_service_contract", "service_contract_key"),
                new("application_log", "log_item_key"),
                new("attachment_log", "attach_item_key"),
                new("html_body_log", "html_item_key"),
                new("parmgrid_log", "parm_item_key"),
                new("post_address_log", "post_item_key"),
                new("sendgrid_event_details", "event_detail_key"),
                new("sendgrid_events", "event_key"),
                new("sendgrid_log", "email_item_key"),
                new("sendgrid_messages", "msg_key"),
                new("sendgrid_template", "email_template_key"),
                new("audit_request", "audit_key")
            };
            
            await CompareTablesSubAsync(tablePairs, _pgConn, _pgConn2);
         }

        private async Task CompareTablesSubAsync(List<TablePair> tablePairs, string pSqlCxn, string pSqlCxn2)
        {
            await using var pgConn = new NpgsqlConnection(pSqlCxn);
            await using var pgConn2 = new NpgsqlConnection(pSqlCxn2);

            await pgConn.OpenAsync();
            await pgConn2.OpenAsync();

            foreach (var pair in tablePairs)
            {
                Console.WriteLine($"\n🔍 Comparing {pair.PgTable} ↔ {pair.PgTable}");
                var pgData = await pgConn.QueryAsync<dynamic>(
                    $"SELECT * FROM {pair.PgTable} ORDER BY {pair.OrderByColumn}");

                var pgData2 = await pgConn2.QueryAsync<dynamic>(
                    $"SELECT * FROM {pair.PgTable} ORDER BY {pair.OrderByColumn}");

                var pgList = pgData.ToList();
                var pgList2 = pgData2.ToList();

                if (pgList.Count != pgList2.Count)
                {
                    Console.WriteLine($"Row count mismatch: PostgreSQL One={pgList.Count}, PostgreSQL Two={pgList2.Count}");
                }

                int maxRows = Math.Max(pgList.Count, pgList.Count);

                for (int i = 0; i < maxRows; i++)
                {
                    if (i >= pgList.Count)
                    {
                        Console.WriteLine($"Extra row in PostgreSQL Two at row {i + 1}:");
                        //Console.WriteLine(pgList[i]);
                        DumpRow(pgList2[i]);
                        continue;
                    }
                    
                    if (i >= pgList2.Count)
                    {
                        Console.WriteLine($"Extra row in PostgreSQL One at row {i + 1}:");
                        //Console.WriteLine(sqlList[i]);
                        DumpRow(pgList[i]);
                        continue;
                    }
                    
                    var pgRow = (IDictionary<string, object>) pgList[i];
                    var pgRow2 = (IDictionary<string, object>) pgList2[i];

                    foreach (var prop in pgRow.Keys)
                    {
                        var pgValue = pgRow[prop];
                        var pgKey2 =(prop);

                        if (!pgRow2.TryGetValue(pgKey2, out var pgValue2))
                        {
                            Console.WriteLine($"Row {i + 1}: PostgreSQL Two column '{pgKey2}' not found.");
                            continue;
                        }

                        if (pgValue is DateTime pgDt && pgValue2 is DateTime pgDt2)
                        {
                            var pgTrunc = pgDt.AddTicks(-(pgDt.Ticks % TimeSpan.TicksPerSecond));
                            var pgTrunc2 = pgDt.AddTicks(-(pgDt2.Ticks % TimeSpan.TicksPerSecond));

                            if (pgTrunc != pgTrunc2)
                            {
                                Console.WriteLine($"Row {i}, column '{pgKey2}': TIMESTAMP mismatch → PG 1 = {pgTrunc}, PG 2 = {pgTrunc2}");
                            }
                        }
                        else if (!Equals(Normalize(pgValue), Normalize(pgValue2)))
                        {
                            Console.WriteLine($"Mismatch in row {i + 1}, column {prop} / {pgKey2}:");
                            Console.WriteLine($"SQL Server: {pgValue}");
                            Console.WriteLine($"PostgreSQL: {pgValue2}");
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
}