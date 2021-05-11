(defsystem :cl-synthesizer-java-sound-client
  :serial t
  :version "0.0.1"
  :depends-on (:cl-java-sound-client :cl-synthesizer)
  :components ((:module "src"
		:serial t
		:components ((:file "packages")
			     (:file "client")))))

(defsystem :cl-synthesizer-java-sound-client/examples
  :serial t
  :version "0.0.1"
  :depends-on (:cl-synthesizer-java-sound-client)
  :components ((:module "example"
		:serial t
		:components ((:file "packages")
			     (:file "example-1")
			     (:file "example-2")))))
