#!/usr/bin/env python3
import rospy
from geometry_msgs.msg import Twist
from pynput import keyboard
from threading import Thread, Lock

class KeyboardController:
    def __init__(self):
        # Initialize the ROS node
        rospy.init_node('keyboard_driver', anonymous=True)

        # Create a Publisher to publish to the /cmd_vel topic, message type Twist
        self.pub = rospy.Publisher('/cmd_vel', Twist, queue_size=10)

        self.linear_speed = 0.0
        self.angular_speed = 0.0
        self.max_linear_speed = 1.0  # Max linear speed
        self.linear_acceleration = 0.05  # Linear acceleration
        self.angular_acceleration = 4  # Angular acceleration
        self.mode = 0  # Mode selection

        # Angular range configuration, stored by mode
        self.angle_limits = {
            0: (-45, 45),
            1: (-90, 90),
            2: (0, 0)
        }

        # Flags to track key states
        self.key_states = {'up': False, 'down': False, 'left': False, 'right': False}
        self.lock = Lock()

    def on_press(self, key):
        try:
            with self.lock:
                if key == keyboard.Key.up:
                    self.key_states['up'] = True
                elif key == keyboard.Key.down:
                    self.key_states['down'] = True
                elif key == keyboard.Key.left:
                    self.key_states['left'] = True
                elif key == keyboard.Key.right:
                    self.key_states['right'] = True
                elif key.char == '0':
                    self.change_mode(0)
                elif key.char == '1':
                    self.change_mode(1)
                elif key.char == '2':
                    self.change_mode(2)
        except AttributeError:
            pass

    def on_release(self, key):
        with self.lock:
            if key == keyboard.Key.up:
                self.key_states['up'] = False
            elif key == keyboard.Key.down:
                self.key_states['down'] = False
            elif key == keyboard.Key.left:
                self.key_states['left'] = False
            elif key == keyboard.Key.right:
                self.key_states['right'] = False

    def update_speeds(self):
        with self.lock:
            # Update linear speed
            if self.key_states['up']:
                self.linear_speed = min(self.max_linear_speed, self.linear_speed + self.linear_acceleration)
            else:
                self.linear_speed = max(-self.max_linear_speed, self.linear_speed - self.linear_acceleration)
            
            # Update angular speed
            if self.key_states['left']:
                self.angular_speed = min(self.angle_limits[self.mode][1], self.angular_speed + self.angular_acceleration)
            elif self.key_states['right']:
                self.angular_speed = max(-self.angle_limits[self.mode][1], self.angular_speed - self.angular_acceleration)
            else:
                self.angular_speed = 0

            # Reset speeds if no key is pressed
            if not any(self.key_states.values()):
                self.linear_speed = 0
                self.angular_speed = 0


    def run(self):
        rospy.loginfo("Keyboard controller is activated.")
        with keyboard.Listener(on_press=self.on_press, on_release=self.on_release) as listener:
            try:
                while not rospy.is_shutdown():
                    self.update_speeds()
                    self.update_motion()
                    rospy.sleep(0.02)
            except Exception as e:
                rospy.logerr(f"Unexpected error: {e}")
            finally:
                listener.stop()

    def update_motion(self):
        twist = Twist()
        twist.linear.x = self.linear_speed
        twist.angular.z = self.angular_speed
        twist.angular.x = self.mode  # Mode encoded into angular.x
        self.pub.publish(twist)

    def change_mode(self, new_mode):
        self.mode = new_mode
        rospy.loginfo(f"Switched to mode: {self.mode}")
        self.adjust_angle_within_limits()

    def adjust_angle_within_limits(self):
        min_angle, max_angle = self.angle_limits[self.mode]
        self.angular_speed = max(min(self.angular_speed, max_angle), min_angle)

if __name__ == '__main__':
    kc = KeyboardController()
    kc.run()
