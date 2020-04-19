#Changeable Parameters
$separator = "_"
$separatorIndex = 3
$removeText = "_KarteNr_"

#Declare
Install-Module PSWritePDF  -Force
Import-Module PSWritePDF
$ExecutionPolicy = Get-ExecutionPolicy
Set-ExecutionPolicy -ExecutionPolicy Bypass
$pdf = gci | Where-Object {$_.Extension -eq ".pdf"}| Sort-Object -Property Name
$pdfPath = gci -Directory
$i =0
clear

#Generate merged PDF in Subfolders
foreach ($file in $pdf) {
  $i++;
  $j = $i-1;
  $createDir = ( $file.Name.Split($separator)[$separatorIndex])
  mkdir $createDir -Force > $null
  $targetFile = $file.DirectoryName + "\" + $createDir + "\" + $file.Name
  Copy-Item $file.FullName $targetFile 
  $mergedPDF = $targetFile  -replace '\d','' -replace $removeText 
  Merge-PDF -InputFile $mergedpdf$j, $targetFile -OutputFile $mergedPDF$i > $null
}
  
#Copy back latest PDF and cleanup Subfolders / PDF's
foreach($mergePath in $pdfPath){
  cd $mergePath.FullName
  $chosenPDF = (gci $mergePath.FullName | sort LastWriteTime | select -last 1) 
  Copy-Item $chosenPDF ../ 
  cd ..
  Remove-Item $mergePath -Force -Recurse
  Move-Item $chosenPDF ($chosenPDF -replace '\d') -Force
  write-host "PDF generated: "$($chosenPDF -replace '\d')
}

#Cleanup & Finish
Set-ExecutionPolicy -ExecutionPolicy $ExecutionPolicy
write-host "done"
pause
