#Changeable Parameters
$separator = "_"
$separatorIndex = 3
$removeText = "_KarteNr_"

#Declare
Install-Module PSWritePDF
Import-Module PSWritePDF
$rootpath = gci | Where-Object {$_.Extension -eq ".pdf" -and $_.Name -match $removeText}| Sort-Object -Property Name
$i =0
$resultFolder = "merged"
clear

#Generate merged PDF in Subfolders
foreach ($file in $rootpath) {
  $i++;
  $groupDir = ( $file.Name.Split($separator)[$separatorIndex])
  mkdir $groupDir -Force > $null
  $targetFile = $file.DirectoryName + "\" + $groupDir + "\" + $file.Name
  Copy-Item $file.FullName $targetFile 
  $mergedPDF = $targetFile  -replace '\d','' -replace $removeText 
  Merge-PDF -InputFile $mergedpdf$i-1, $targetFile -OutputFile $mergedPDF$i > $null
}
  
#Copy back latest PDF and cleanup Subfolders / PDF's
$pdfPaths = gci -Directory -Exclude $resultFolder
mkdir $resultFolder -Force
foreach($pdfPath in $pdfPaths){
  cd $pdfPath.FullName
  $chosenPDFsrc = (gci $pdfPath.FullName | sort LastWriteTime | select -last 1) 
  $chosenPDFtrg = $chosenPDFsrc -replace '\d'
  Move-Item $chosenPDFsrc ../$resultFolder/$chosenPDFtrg -Force
  cd ..
  Remove-Item $pdfPath -Force -Recurse
  write-host `PDF generated: $chosenPDFtrg`
}

#Cleanup & Finish
Set-ExecutionPolicy -ExecutionPolicy Undefined #if rerun, comment line
write-host "done"
explorer ./$resultFolder
