(load "package://cobottaeus/cobotta-oss-interface.l")
(load "package://cobotta_precise_ik_test/robots/cobottax100.l")

(defmethod cobottax100-robot
  (:arm (&rest args) (send* self :rarm args))      ;; enable to call send *cobottax100* :arm :angle-vector
  )

(defmethod cobotta-robot
  (:test-init-pose ()
    (send self :angle-vector #f(-10.094 -16.3036 108.178 4.48656 -60.5562 0.91869))))

(defun calc-ik-pos-error
  (target-coords)
  (format t "Positional error between target-coords and IK result: ~a~%"
          (norm (v- (send target-coords :worldpos)
                    (send *cobotta* :arm :end-coords :worldpos)))))

(defun test-normal-ik
  (target-coords &key (thre 1) (rthre (deg2rad 1)))
  (send *cobotta* :test-init-pose)
  (if (send *cobotta* :arm :inverse-kinematics
            target-coords :thre thre :rthre rthre :warnp nil)
    (progn
      (format t "~%Normal IK (target-coords: ~a, thre: ~a, rthre: ~a) succeeded~%"
              target-coords thre rthre)
      (calc-ik-pos-error target-coords))
    (progn
      (format t "~%Normal IK (target-coords: ~a, thre: ~a, rthre: ~a) failed~%"
              target-coords thre rthre))))

(defun test-ik-with-cobottax100
  (target-coords &key (thre 1) (rthre (deg2rad 1)))
  (send *cobotta* :test-init-pose)
  (send *cobottax100* :angle-vector (send *cobotta* :angle-vector))
  (let (target-coords-x100)
    (setq target-coords-x100 (send target-coords :copy-worldcoords))
    (send target-coords-x100 :locate (scale 100 (send target-coords :worldpos)) :world)
    (if (send *cobottax100* :arm :inverse-kinematics
              target-coords-x100 :thre (* 100 thre) :rthre rthre :warnp nil)
      (progn
        (format t "~%IK with cobottax100 (target-coords: ~a, thre: ~a, rthre: ~a) succeeded~%"
                target-coords thre rthre)
        (send *cobotta* :angle-vector (send *cobottax100* :angle-vector))
        (calc-ik-pos-error target-coords))
      (progn
        (format t "~%IK with cobottax100 (target-coords: ~a, thre: ~a, rthre: ~a) failed~%"
                target-coords thre rthre)))))

(defun test ()
  (cobotta)
  (cobottax100)

  (let (target-coords)
    (send *cobotta* :test-init-pose)
    (setq target-coords
          (send (send *cobotta* :arm :end-coords :copy-worldcoords)
                :translate #f(0 0 -30) :world))

    (test-normal-ik target-coords :thre 0.1)  ;; Test 1
    (test-normal-ik target-coords :thre 0.05)  ;; Test 2
    (test-normal-ik target-coords :thre 0.001)  ;; Test 3
    (test-ik-with-cobottax100 target-coords :thre 0.1)  ;; Test 4
    (test-ik-with-cobottax100 target-coords :thre 0.05)  ;; Test 5
    (test-ik-with-cobottax100 target-coords :thre 0.001)  ;; Test 6
    ))
