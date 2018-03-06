; This script is designed to generate basic thumbnail images for Youtube videos
; Create your thumbnail image, add a text layer with the size/font/colour of your desired episode numbers
; Run the script and set the start and end values, PNG thumbnail images will be generated for those values in the same folder and with the same name as the xcf used to generate them (seriesName.xcf will generate seriesName 01.png, seriesName 02.png, etc)
; The script will automatically amend values below ten with 0 (1 is displayed as 01, 2 as 02, etc)
; The script will not adjust the width of the text field if it cannot accommodate the amount of numbers entered (you may need to adjust the text field before running the script when exceeding 100, 1000, etc)

(define (generate-numbered-thumbnails inImage inLayer inStartInt inEndInt)
	(gimp-image-undo-disable inImage)
	(let ((iter inStartInt) (fileName (drop-extension (car (gimp-image-get-filename inImage)))))
		(while (<= iter inEndInt)
			(let ((iterAsString (number->string iter)))
				(if(< iter 10)
					(set! iterAsString (string-append "0" iterAsString))
				)
				(gimp-text-layer-set-text inLayer iterAsString)
				(set! iter (+ iter 1))
				(gimp-displays-flush)
				
				(let ((tempImage (car (gimp-image-duplicate inImage))))
					(file-png-save-defaults 
						RUN-NONINTERACTIVE 
						tempImage 
						(car (gimp-image-merge-visible-layers tempImage CLIP-TO-IMAGE)) 
						(string-append fileName " " iterAsString ".png")
						(string-append fileName " " iterAsString ".png")
					)
				)
			)
		)
	)
	(gimp-image-undo-enable inImage)
)
	
(define (drop-extension filename)
  (unbreakupstr (reverse (cdr (reverse (strbreakup filename ".")))) ".")
)

(script-fu-register 
	"generate-numbered-thumbnails"
	"Generate Numbered Thumbnails"
	"Generates numbered thumbnail images between entered range. The currently selected layer when launching the script must be a text layer"
	"Barodas"
	"copyright 2018, Barodas"
	"March 6, 2018"
	""
	SF-IMAGE "Image" 0
	SF-DRAWABLE "ActiveLayer" 0
	SF-VALUE "StartValue" "0"
	SF-VALUE "EndValue" "0"
)

(script-fu-menu-register "generate-numbered-thumbnails" "<Image>/File/Export")