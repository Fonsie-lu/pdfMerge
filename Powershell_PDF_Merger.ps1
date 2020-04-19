Install-Module PSWritePDF  -Force
$ExecutionPolicy = Get-ExecutionPolicy
Set-ExecutionPolicy -ExecutionPolicy Bypass
$i =0
clear

$pdf = gci | Where-Object {$_.Extension -eq ".pdf"}| Sort-Object -Property Name
foreach ($file in $pdf) {
$i++;
$j = $i-1;
Import-Module PSWritePDF
$createDir = ( $file.Name.Split('_')[3])
mkdir $createDir -Force > $null
$targetFile = $file.DirectoryName + "\" + $createDir + "\" + $file.Name
Copy-Item $file.FullName $targetFile 
$mergedPDF = $targetFile  -replace '\d','' -replace '_KarteNr_'
Merge-PDF -InputFile $mergedpdf$j, $targetFile -OutputFile $mergedPDF$i > $null
}

$pdfPath = gci -Directory
foreach($mergePath in $pdfPath){
cd $mergePath.FullName
$chosenPDF = gci $mergePath.FullName | sort LastWriteTime | select -last 1
Copy-Item $chosenPDF ../ 
cd ..
Remove-Item $mergePath -Force -Recurse
Move-Item $chosenPDF ($chosenPDF -replace '\d') -Force
}
Set-ExecutionPolicy -ExecutionPolicy $ExecutionPolicy
write-host "done"