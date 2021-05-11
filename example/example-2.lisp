(in-package :cl-synthesizer-java-sound-client-example-2)

(defun make-voice (name environment &key lfo-frequency vco-frequency)
  "Frequency modulated saw"
  (declare (ignore name))
  (let ((voice
      (cl-synthesizer:make-rack
       :environment environment
       :output-sockets '(:audio))))

    (cl-synthesizer:add-module
     voice "LFO"
     #'cl-synthesizer-modules-vco:make-module
     :base-frequency lfo-frequency :v-peak 5.0)

    (cl-synthesizer:add-module
     voice "VCO"
     #'cl-synthesizer-modules-vco:make-module
     :base-frequency vco-frequency :v-peak 5.0 :cv-lin-hz-v 20.0)

    (cl-synthesizer:add-patch voice "LFO" :sine "VCO" :cv-lin)
    (cl-synthesizer:add-patch voice "VCO" :saw "OUTPUT" :audio)
    
    voice))

(defun make-rack ()
  (let ((rack (cl-synthesizer:make-rack
               :environment (cl-synthesizer:make-environment)
	       :output-sockets '(:left :right))))
    (cl-synthesizer:add-module
     rack "VOICE-1" #'make-voice :lfo-frequency 1.0 :vco-frequency 440.0)
    (cl-synthesizer:add-module
     rack "VOICE-2" #'make-voice :lfo-frequency 2.0 :vco-frequency 442.0)
    (cl-synthesizer:add-patch rack "VOICE-1" :audio "OUTPUT" :left)
    (cl-synthesizer:add-patch rack "VOICE-2" :audio "OUTPUT" :right)
    rack))

(defun main ()
  (cl-java-sound-client-logger:set-log-level :info)
  (let ((rack (make-rack)))
    (let ((my-controller
	    (make-instance
	     'cl-synthesizer-controller
	     :rack rack
	     :output-sockets
	     '(("OUTPUT" :input-socket :left)
	       ("OUTPUT" :input-socket :right))
	     :duration-seconds 5
	     :sample-width :16Bit
	     :v-peak 5.0)))
      (cl-java-sound-client:connect
       my-controller
       :port 9000
       :host "localhost"
       :buffer-size-frames 10000
       :omit-audio-output nil)
      (cl-java-sound-client:run my-controller))))

;;(main)