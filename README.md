# cobotta_precise_ik_test

## How to install

1. Follow https://github.com/jsk-ros-pkg/jsk_robot/tree/master/jsk_denso_robot#how-to-setup-development-environment-on-your-pc
2. Install this package:
   ```bash
   # Do not forget "source ~/denso_ws/devel/setup.bash"
   mkdir -p ~/ws_cobotta_precise_ik_test/src
   cd ~/ws_cobotta_precise_ik_test/src
   git clone https://github.com/pazeshun/cobotta_precise_ik_test.git
   cd ..
   catkin build
   source ~/ws_cobotta_precise_ik_test/devel/setup.bash
   ```

## How to use

```lisp
roseus `rospack find cobotta_precise_ik_test`/euslisp/cobotta-precise-ik-test.l
(test)  ;; IK tests run
```
