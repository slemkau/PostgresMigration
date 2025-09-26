# Simple Dockerfile for published ASP.NET MVC 4.8 app (Fixed)
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2022

WORKDIR /inetpub/wwwroot

# Copy your published application
COPY . .

# Configure IIS for MVC routing (simplified - no virtual directory cleanup)
RUN powershell -Command \
    Import-Module WebAdministration; \
    Set-WebConfiguration -Filter '/system.webServer/defaultDocument' -PSPath 'IIS:\' -Value @{enabled='false'}; \
    Set-WebConfiguration -Filter '/system.webServer/modules' -PSPath 'IIS:\' -Value @{runAllManagedModulesForAllRequests='true'};

EXPOSE 80

# Health check using your /healthcheck endpoint
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD powershell -command "try { $response = Invoke-WebRequest -Uri http://localhost/healthcheck -UseBasicParsing -TimeoutSec 5; if ($response.StatusCode -eq 200) { exit 0 } else { exit 1 } } catch { exit 1 }"
