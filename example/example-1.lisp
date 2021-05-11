(in-package :cl-synthesizer-java-sound-client-example-1)

(defun make-rack ()
  (let ((rack (cl-synthesizer:make-rack
               :environment (cl-synthesizer:make-environment)
	       :output-sockets '(:sine))))
    (cl-synthesizer:add-module
     rack
     "VCO"
     #'cl-synthesizer-modules-vco:make-module
     :base-frequency 440.0 :v-peak 5.0)
    (cl-synthesizer:add-patch rack "VCO" :sine "OUTPUT" :sine)
    rack))

(defun main ()
  (cl-java-sound-client-logger:set-log-level :info)
  (let ((my-controller
	  (make-instance
	   'cl-synthesizer-controller
	   :rack (make-rack)
	   :output-sockets '(("OUTPUT" :input-socket :sine))
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
