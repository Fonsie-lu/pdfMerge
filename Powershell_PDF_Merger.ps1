#Changeable Parameters
$separator = "_"
$separatorIndex = 3
$removeText = "_KarteNr_"

#Declare
Install-Module PSWritePDF
Import-Module PSWritePDF
$ExecutionPolicy = Get-ExecutionPolicy
Set-ExecutionPolicy -ExecutionPolicy Bypass
$rootpath = gci | Where-Object {$_.Extension -eq ".pdf" -and $_.Name -match $removeText}| Sort-Object -Property Name
$i =0
clear

#Generate merged PDF in Subfolders
foreach ($file in $rootpath) {
  $i++;
  $j = $i-1;
  $groupDir = ( $file.Name.Split($separator)[$separatorIndex])
  mkdir $groupDir -Force > $null
  $targetFile = $file.DirectoryName + "\" + $groupDir + "\" + $file.Name
  Copy-Item $file.FullName $targetFile 
  $mergedPDF = $targetFile  -replace '\d','' -replace $removeText 
  Merge-PDF -InputFile $mergedpdf$j, $targetFile -OutputFile $mergedPDF$i > $null
}
  
#Copy back latest PDF and cleanup Subfolders / PDF's
$pdfPaths = gci -Directory
foreach($pdfPath in $pdfPaths){
  cd $pdfPath.FullName
  $chosenPDFsrc = (gci $pdfPath.FullName | sort LastWriteTime | select -last 1) 
  $chosenPDFtrg = $chosenPDFsrc -replace '\d'
  Move-Item $chosenPDFsrc ../$chosenPDFtrg -Force
  cd ..
  Remove-Item $pdfPath -Force -Recurse
  write-host `PDF generated: $chosenPDFtrg`
}

#Cleanup & Finish
Set-ExecutionPolicy -ExecutionPolicy $ExecutionPolicy
write-host "done"