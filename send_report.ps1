Add-Type -AssemblyName System.Web

$uri = 'https://support.fsa.gov.ru/php/reports_send/metrology_report_send.php';
$boundary = "----WebKitFormBoundary" + [System.Guid]::NewGuid().ToString().replace('-', '').ToUpper()

$lf = "`n";
$lines = (
  "--$boundary",
  "Content-Disposition: form-data; name=`"form_type`"$lf",
  "measurements",
  
  "--$boundary",
  "Content-Disposition: form-data; name=`"accr_cert_num`"$lf",
  "RA.RU.123456",
  
  "--$boundary",
  "Content-Disposition: form-data; name=`"metrology_email`"$lf",
  "<your_email_here>",
  
  "--$boundary",
  "Content-Disposition: form-data; name=`"measurements_check_number`"$lf",
  "11111-11",
  
  "--$boundary",
  "Content-Disposition: form-data; name=`"measurements_check_date`"$lf",
  "2021-12-01",
  
  "--$boundary",
  "Content-Disposition: form-data; name=`"measurements_limitation`"$lf",
  "2021-11-30",
  
  "--$boundary",
  "Content-Disposition: form-data; name=`"measurements_measurement_type`"$lf",
  "МП 2011-11111",
  
  "--$boundary",
  "Content-Disposition: form-data; name=`"measurements_measurement_result`"$lf",
  "пригоден к использованию",
  
  "--$boundary",
  "Content-Disposition: form-data; name=`"measurements_verification_surname`"$lf",
  "Пупкин",
  
  "--$boundary",
  "Content-Disposition: form-data; name=`"measurements_verification_name`"$lf",
  "Яков",
  
  "--$boundary",
  "Content-Disposition: form-data; name=`"measurements_verification_patronymic`"$lf",
  "Иванович",
  
  "--$boundary--"
) -join $lf


$headers = @{
  'Accept' = "application/json, text/javascript, */*; q=0.01"
  'Accept-Encoding' = "gzip, deflate, br"
  'Accept-Language' = "en-US,en;q=0.9"
  'Content-Length' = "$($lines.Length)"
  'Content-Type' = "multipart/form-data; boundary=`"$boundary`""
  'Host' = "support.fsa.gov.ru"
  'Origin' = "https://support.fsa.gov.ru"
  'Referer' = "https://support.fsa.gov.ru/"
  'User-Agent' = "Mozilla/5.0"
  'X-Requested-With' = "XMLHttpRequest"
  'DNT' = "1"
}


Clear-Variable result
Clear-Variable responseBody

try {
  $result = Invoke-WebRequest -Uri $uri -DisableKeepAlive -Headers $headers -Method Post -Body $lines 
}
catch {
  $result = $_.Exception.Response.GetResponseStream()
  $reader = New-Object System.IO.StreamReader($result)
  $reader.BaseStream.Position = 0
  $reader.DiscardBufferedData()
  $responseBody = $reader.ReadToEnd();
}

if ($result)
{
  $result
}
if ($responseBody)
{
  $responseBody
}
