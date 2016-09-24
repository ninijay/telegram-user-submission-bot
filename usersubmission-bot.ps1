$botkey = ""
$YOUR_CHANNEL_ID = ""
$Channelname = ""
$botname=""
$timeout = 60
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
$state = -1
$offset = 0

write-host $botkey

while($true) {
	$updateparams = $getUpdatesLink + '?offset='+$offset +'&timeout=' + $timeout
	$json = Invoke-WebRequest -Uri $updateparams -UseBasicParsing | ConvertFrom-Json
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
            $startmsg= $sendMessageLink + '?chat_id=' + $json.result[$i].message.chat.id + '&text=Welcome to the ' + $Channelname + ' User Submission bot. Please send us your images and videos ;)'
            Invoke-WebRequest -Uri $startmsg -UseBasicParsing
        }
        else
        {
            # Image resending
            Try
            {
              $fulllink = $sendPhotoLink + '?chat_id='+ $YOUR_CHANNEL_ID +'&photo=' + $json.result[$i].message.photo.file_id[0] + '&caption=Send your own stuff at ' + $botname
              Write-Host $fulllink
              Invoke-WebRequest -Uri $fulllink -UseBasicParsing
              $startmsg= $sendMessageLink + '?chat_id=' + $json.result[$i].message.chat.id + '&text=Thank you for sending the image, you can check it out at ' + $YOUR_CHANNEL_ID
              Invoke-WebRequest -Uri $startmsg -UseBasicParsing
              $state = 0
            }
            Catch
            {
                $state = -2        
            }

            if($state -le -1)
            {
                # Video resending
                Try
                {
                  $fulllink = $sendVideoLink + '?chat_id='+ $YOUR_CHANNEL_ID +'&video=' + $json.result[$i].message.video.file_id + '&caption=Send your own stuff at ' + $botname
                  Write-Host $fulllink
                  Invoke-WebRequest -Uri $fulllink -UseBasicParsing
                  $startmsg= $sendMessageLink + '?chat_id=' + $json.result[$i].message.chat.id + '&text=Thank you for sending the video, you can check it out at ' + $YOUR_CHANNEL_ID
                  Invoke-WebRequest -Uri $startmsg -UseBasicParsing
                  $state = 0   
                }
                Catch
                {
                    $state = -3           
                }
            }

            if($state -le -1)
            {
                switch($state){
                    -1 { $error_api= $sendMessageLink + '?chat_id=' + $json.result[$i].message.chat.id + '&text=There was an unknown error. Please try again...' }
                    -2 { $error_api= $sendMessageLink + '?chat_id=' + $json.result[$i].message.chat.id + '&text=please send a valid image...'
                            Write-Host $_.Exception.Message
                            Invoke-WebRequest -Uri $error_api -UseBasicParsing
                       }
                    -3 {  $error_api= $sendMessageLink + '?chat_id=' + $json.result[$i].message.chat.id + '&text=please send a valid video...'
                            Write-Host $_.Exception.Message
                            Invoke-WebRequest -Uri $error_api -UseBasicParsing
                       }
                }
            }
                        
        }
        
		$i++
	}
	Start-Sleep -s 2
}
