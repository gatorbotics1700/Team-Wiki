2026 Season Vision
==================

Summary
-------

* Switched from Limelight to PhotonVision
* Set up new cameras and coprocessors
* Developed YOLO11 models for detecting fuel
* Created a framework for identifying and driving towards fuel position

Software
--------

For software setup and use instructions, see the `PhotonVision Docs <https://docs.photonvision.org/>`_.

Hardware
--------

We used Arducam OV9281 (monochrome) and Arducam OV9782 (color) cameras, which
connected via USB to a RUBIK Pi 3. We powered our two RUBIK Pis using a
Buck-Boost power converter.

Model Development
-----------------

We took various pictures of fuel with our cameras and downloaded them through the
PhotonVision site. We combined this dataset with one we found online and used
Roboflow to create bounding boxes. Next, we used Google Colab to use the dataset
to train a YOLO11 model and convert it into a ``.tflite`` file.

Code
----

In the ``getFuelPose()`` method in ``Vision.java``, we used 3D linear equations to
calculate the pose of a piece of field based on the position of the detected object
in the camera frame.

.. code-block:: java

   cameraInFieldSpace =
       cameraInFieldSpace.transformBy(
           new Transform3d(
               new Translation3d(),
               new Rotation3d(
                   0,
                   Math.toRadians(targetPitchDegrees),
                   Math.toRadians(targetYawDegrees))));
   // create a 3d point translated an arbitrary distance out from the camera from where the
   // fuel is
   Translation3d towardFuelInRobotSpace =
       cameraInFieldSpace
           .transformBy(
               new Transform3d(
                   new Translation3d(
                       Centimeters.of(100), Centimeters.of(0), Centimeters.of(0)),
                   new Rotation3d()))
           .getTranslation();
   // use two known points(cameraInFieldSpace,towardFuelInRobotSpace) to create a 3d linear
   // equation
   double deltaX = towardFuelInRobotSpace.getX() - cameraInFieldSpace.getX();
   double deltaY = towardFuelInRobotSpace.getY() - cameraInFieldSpace.getY();
   double deltaZ = towardFuelInRobotSpace.getZ() - cameraInFieldSpace.getZ();
   final Distance fuelRadius = Centimeters.of(7.5);
   // we know the fuel is on the ground. use the equation to solve for fuelpose
   Distance fuelPoseX =
       (fuelRadius.minus(cameraInFieldSpace.getMeasureZ()))
           .div(deltaZ)
           .times(deltaX)
           .plus(cameraInFieldSpace.getMeasureX());
   Distance fuelPoseY =
       (fuelRadius.minus(cameraInFieldSpace.getMeasureZ()))
           .div(deltaZ)
           .times(deltaY)
           .plus(cameraInFieldSpace.getMeasureY());
   fuelPose = new Pose2d(fuelPoseX, fuelPoseY, new Rotation2d());
