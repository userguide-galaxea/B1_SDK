;; Auto-generated. Do not edit!


(when (boundp 'signal_chassis::ControlCommand)
  (if (not (find-package "SIGNAL_CHASSIS"))
    (make-package "SIGNAL_CHASSIS"))
  (shadow 'ControlCommand (find-package "SIGNAL_CHASSIS")))
(unless (find-package "SIGNAL_CHASSIS::CONTROLCOMMAND")
  (make-package "SIGNAL_CHASSIS::CONTROLCOMMAND"))

(in-package "ROS")
;;//! \htmlinclude ControlCommand.msg.html
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass signal_chassis::ControlCommand
  :super ros::object
  :slots (_header _motion_mode _x _y _w ))

(defmethod signal_chassis::ControlCommand
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:motion_mode __motion_mode) 0)
    ((:x __x) 0.0)
    ((:y __y) 0.0)
    ((:w __w) 0.0)
    )
   (send-super :init)
   (setq _header __header)
   (setq _motion_mode (round __motion_mode))
   (setq _x (float __x))
   (setq _y (float __y))
   (setq _w (float __w))
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:motion_mode
   (&optional __motion_mode)
   (if __motion_mode (setq _motion_mode __motion_mode)) _motion_mode)
  (:x
   (&optional __x)
   (if __x (setq _x __x)) _x)
  (:y
   (&optional __y)
   (if __y (setq _y __y)) _y)
  (:w
   (&optional __w)
   (if __w (setq _w __w)) _w)
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; uint8 _motion_mode
    1
    ;; float32 _x
    4
    ;; float32 _y
    4
    ;; float32 _w
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; uint8 _motion_mode
       (write-byte _motion_mode s)
     ;; float32 _x
       (sys::poke _x (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _y
       (sys::poke _y (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _w
       (sys::poke _w (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; uint8 _motion_mode
     (setq _motion_mode (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; float32 _x
     (setq _x (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _y
     (setq _y (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _w
     (setq _w (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get signal_chassis::ControlCommand :md5sum-) "b2b9a7a87c329141f319bbacc441de60")
(setf (get signal_chassis::ControlCommand :datatype-) "signal_chassis/ControlCommand")
(setf (get signal_chassis::ControlCommand :definition-)
      "std_msgs/Header header
uint8 motion_mode
float32 x
float32 y
float32 w
================================================================================
MSG: std_msgs/Header
# Standard metadata for higher-level stamped data types.
# This is generally used to communicate timestamped data 
# in a particular coordinate frame.
# 
# sequence ID: consecutively increasing ID 
uint32 seq
#Two-integer timestamp that is expressed as:
# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
# time-handling sugar is provided by the client library
time stamp
#Frame this data is associated with
string frame_id

")



(provide :signal_chassis/ControlCommand "b2b9a7a87c329141f319bbacc441de60")


