(in-package :cl-synthesizer-java-sound-client-example-2)

(defun make-voice (name environment &key lfo-frequency vco-frequency)
  "Frequency modulated saw"
  (declare (ignore name))
  (let ((voice
      (cl-synthesizer:make-rack :environment environment)))

    (cl-synthesizer:add-module
     voice "LFO"
     #'cl-synthesizer-modules-vco:make-module
     :base-frequency lfo-frequency :v-peak 5.0)

    (cl-synthesizer:add-module
     voice "VCO"
     #'cl-synthesizer-modules-vco:make-module
     :base-frequency vco-frequency :v-peak 5.0 :cv-lin-hz-v 20.0)

    (cl-synthesizer:add-patch voice "LFO" :sine "VCO" :cv-lin)
    (cl-synthesizer:expose-output-socket voice :audio "VCO" :saw)

    voice))

(defun make-rack ()
  (let ((rack (cl-synthesizer:make-rack
               :environment (cl-synthesizer:make-environment))))
    (cl-synthesizer:add-module
     rack "VOICE-1" #'make-voice :lfo-frequency 1.0 :vco-frequency 440.0)
    (cl-synthesizer:add-module
     rack "VOICE-2" #'make-voice :lfo-frequency 2.0 :vco-frequency 442.0)

    ;; (cl-synthesizer:expose-output-socket rack :left "VOICE-1" :audio)
    ;; (cl-synthesizer:expose-output-socket rack :right "VOICE-2" :audio)
    rack))

(defun main ()
  (cl-java-sound-client-logger:set-log-level :info)
  (let ((my-controller
	  (make-instance
	   'cl-synthesizer-controller
	   :rack (make-rack)
	   :output-sockets
	   '(("VOICE-1" :output-socket :audio)
	     ("VOICE-2" :output-socket :audio))
	   :duration-seconds 5
	   :sample-width :16Bit
	   :v-peak 5.0)))
    (cl-java-sound-client:connect
     my-controller
     :port 9000
     :host "localhost"
     :buffer-size-frames 10000
     :omit-audio-output nil)
    (cl-java-sound-client:run my-controller)))

;;(main)
