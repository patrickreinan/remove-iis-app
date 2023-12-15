
# Specify website parameters
$websiteName = "Default Web Site"
$appPool = "DefaultAppPool"

# Specify web application parameters
$webAppName = "TestApp"
$webAppPath = "C:\inetpub\wwwroot\testapp"

mkdir $webAppPath -Force
echo "hello world" >> $webAppPath\index.html

# Create a new web application
New-WebApplication -Name $webAppName -Site $websiteName -PhysicalPath $webAppPath -ApplicationPool $appPool -Force