#Changeable Parameters
$separator = "_"
$separatorIndex = 3
#$removeText = "_KarteNr_"

#Declare
Install-Module PSWritePDF -Force
Import-Module PSWritePDF
$rootpath = gci | Where-Object {$_.Extension -eq ".pdf"}| Sort-Object -Property Name
$current = 1
$resultFolder = "merged"
clear

#Generate merged PDF in Subfolders
foreach ($file in $rootpath) {
  $prev = $current
  $current++;
  $groupDir = ( $file.Name.Split($separator)[$separatorIndex])
  mkdir $groupDir -Force > $null
  $targetFile = $file.DirectoryName + "\" + $groupDir + "\" + $file.Name
  Copy-Item $file.FullName $targetFile 
  $mergedPDF = $targetFile  -replace '\d','' #-replace $removeText 
  Merge-PDF -InputFile $mergedpdf$prev, $targetFile -OutputFile $mergedPDF$current > $null
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
explorer .\$resultFolder
