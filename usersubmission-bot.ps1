$botkey = "YOUR TOKEN"

$getMeLink = "https://api.telegram.org/bot$botkey/getMe"
$sendMessageLink = "https://api.telegram.org/bot$botkey/sendMessage"
$forwardMessageLink = "https://api.telegram.org/bot$botkey/forwardMessage"
$sendPhotoLink = "https://api.telegram.org/bot$botkey/sendPhoto"
$sendAudioLink = "https://api.telegram.org/bot$botkey/sendAudio"
$sendDocumentLink = "https://api.telegram.org/bot$botkey/sendDocument"
$sendStickerLink = "https://api.telegram.org/bot$botkey/sendSticker"
$sendVideoLink = "https://api.telegram.org/bot$botkey/sendVideo"
$sendLocationLink = "https://api.telegram.org/bot$botkey/sendLocation"
$sendChatActionLink = "https://api.telegram.org/bot$botkey/sendChatAction"
$getUserProfilePhotosLink = "https://api.telegram.org/bot$botkey/getUserProfilePhotos"
$getUpdatesLink = "https://api.telegram.org/bot$botkey/getUpdates"
$setWebhookLink = "https://api.telegram.org/bot$botkey/setWebhook"

$offset = 0
write-host $botkey

while($true) {
	$json = Invoke-WebRequest -Uri $getUpdatesLink -Body @{offset=$offset} | ConvertFrom-Json
	Write-Host $json
	Write-Host $json.ok
	$l = $json.result.length
	$i = 0
	Write-Host $json.result
	Write-Host $json.result.length
	while ($i -lt $l) {
		$offset = $json.result[$i].update_id + 1
		Write-Host "New offset: $offset"
		Write-Host $json.result[$i].message
        $txt = $json.result[$i].message.text
        Write-Host $txt
        if( $txt -eq '/start')
        {
            $startmsg= $sendMessageLink + '?chat_id=' + $json.result[$i].message.chat.id + '&text=Welcome to the Dark Jokes User Submission bot. Please send us your images ;)'
            Invoke-WebRequest -Uri $startmsg
        }
        else
        {
            # Image resending
            Try
            {
              $fulllink = $sendPhotoLink + '?chat_id=YOUR CHANNEL ID&photo=' + $json.result[$i].message.photo.file_id[0]
              Write-Host $fulllink
              Invoke-WebRequest -Uri $fulllink
            
            }
            Catch
            {
                $error_api= $sendMessageLink + '?chat_id=' + $json.result[$i].message.chat.id + '&text=please send a valid image...'
                Invoke-WebRequest -Uri $error_api
            }
        }
        
		$i++
	}
	Start-Sleep -s 2
}
