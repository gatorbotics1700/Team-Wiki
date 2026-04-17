Four-Bar Intake (2026)
=============

The Intake continuously picks up fuel pieces and guides them into the powered
hopper floor transition. As a 4-bar linkage, it retracts upon impact.

Overview
--------

- **Mechanism type:** 4-bar intake linkage
- **Purpose:** Collect and feed fuel pieces to hopper transition
- **Behavior:** Retracts on impact for compliance and durability

Hardware
--------

Physical design, drivetrain layout, sensors on the mechanism, CAD link, and
photos.

Mechanical Construction
^^^^^^^^^^^^^^^^^^^^^^^

- **Frame:** 1/4" aluminum side plates + 1/4" polycarbonate linkages
- **Rollers:** 3 pulleyed rollers with 2.125" compliance wheels

Power Transmission
^^^^^^^^^^^^^^^^^^

Deploy
""""""

- 9:1 Kraken x60 through 90-degree gearbox

Rollers
"""""""

- 3:1 Kraken x44 through 90-degree gearbox
- Co-axial pulley allows for spinning

Sensors and Zeroing
^^^^^^^^^^^^^^^^^^^

- 1x hall effect sensor
- Zeros the deploy motor position when the intake is fully retracted

CAD
^^^

- `CAD model <https://cad.onshape.com/documents/1a00082b7901ad05e68a8dcc/w/d9b41b69ede54a1e9320bbd2/e/b2b6161758864477a2a14a47?renderMode=0&uiState=69e1ab8c16ec66f573ee0b7c>`_

Image Gallery
^^^^^^^^^^^^^

CAD screenshot:

.. figure:: /_static/images/intake/intake-2026-cad.png
   :alt: Intake 2026 CAD screenshot
   :width: 90%
   :align: center

   Intake (2026) CAD overview.

Add more rendered CAD screenshots and real robot photos here.

Software
--------

Controlling motion of this intake was speed-based, with the mechanism always
trying to go to either the deployed or retracted hall effect sensor, since the
deploy belt constantly skipped.

Subsystem (IntakeSubsystem.java)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Two-motor split
"""""""""""""""

One motor deploys/retracts the 4-bar, and one motor runs the intake rollers.

.. code-block:: java

   private final TalonFX intakeMotor;
   private final TalonFX deployMotor;

Motor Configuration
"""""""""""""""""""

Motor output direction and current limiting are configured up front for both
deploy and intake motors.

.. code-block:: java

   // Intake motor configuration
   intakeTalonFXConfigs =
       new TalonFXConfiguration()
           .withMotorOutput(
               new MotorOutputConfigs().withInverted(InvertedValue.CounterClockwise_Positive));

   intakeCurrentLimitConfigs = intakeTalonFXConfigs.CurrentLimits;
   intakeCurrentLimitConfigs.StatorCurrentLimit = 25;
   intakeCurrentLimitConfigs.StatorCurrentLimitEnable = true;

   intakeMotor.getConfigurator().apply(intakeTalonFXConfigs);

Goal-based deploy state
"""""""""""""""""""""""

Control tracks a deploy goal (extended vs retracted) and drives toward the
matching hall sensor.

.. code-block:: java

   if (deployGoalExtended && !deployedHall) {
     deployMotor.set(-IntakeConstants.HOMING_SPEED);
   } else if (!deployGoalExtended && !retractHall) {
     deployMotor.set(IntakeConstants.HOMING_SPEED);
   } else {
     deployMotor.set(0);
   }

Angle and revolution conversion
"""""""""""""""""""""""""""""""

Gear ratios are used to convert Falcon motor revolutions into deploy mechanism
angle.

.. code-block:: java

   public double degreesToRevs(double deployAngleDegrees) {
     return deployAngleDegrees / 360.0
         * IntakeConstants.DEPLOY_PULLEY_TWO_GEAR_RATIO
         * IntakeConstants.DEPLOY_PULLEY_ONE_GEAR_RATIO
         * IntakeConstants.DEPLOY_GEARBOX_RATIO;
   }

Commands (IntakeCommands.java)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The intake command layer wraps the subsystem behavior into named deploy/retract
and roller actions.

Seek-until-hall pattern (retract homing)
""""""""""""""""""""""""""""""""""""""""

.. code-block:: java

   private static Command seekUntilRetractHall(IntakeSubsystem intakeSubsystem) {
     return Commands.sequence(
         new InstantCommand(
             () -> {
               if (intakeSubsystem.isHallEffectTriggered()) {
                 intakeSubsystem.zeroIntakeDeploy(true);
               } else {
                 intakeSubsystem.setDeploySpeed(IntakeConstants.HOMING_SPEED);
               }
             },
             intakeSubsystem),
         Commands.deadline(
                 Commands.waitUntil(intakeSubsystem::isHallEffectTriggered).withTimeout(10),
                 Commands.run(
                     () -> intakeSubsystem.setDeploySpeed(IntakeConstants.HOMING_SPEED),
                     intakeSubsystem))
             .finallyDo(intakeSubsystem::clearDeployManualControl),
         new InstantCommand(() -> intakeSubsystem.setDeployGoalExtended(false), intakeSubsystem));
   }

Deploy / retract / toggle commands
""""""""""""""""""""""""""""""""""

.. code-block:: java

   public static Command ToggleIntake(IntakeSubsystem intakeSubsystem) {
     if (intakeSubsystem.getIsDeployed().getAsBoolean()) {
       return RetractIntake(intakeSubsystem);
     } else {
       return DeployIntake(intakeSubsystem);
     }
   }

   public static Command RetractIntake(IntakeSubsystem intakeSubsystem) {
     return seekUntilRetractHall(intakeSubsystem).withName("Retract Intake");
   }

   public static Command DeployIntake(IntakeSubsystem intakeSubsystem) {
     return seekUntilDeployedHall(intakeSubsystem).withName("Deploy Intake");
   }

Roller control commands
"""""""""""""""""""""""

.. code-block:: java

   public static Command RunIntake(IntakeSubsystem intakeSubsystem) {
     return new InstantCommand(
             () -> intakeSubsystem.setIntakeSpeed(IntakeConstants.INTAKING_SPEED))
         .withName("Run Intake");
   }

   public static Command ReverseIntake(IntakeSubsystem intakeSubsystem) {
     return new InstantCommand(
             () -> intakeSubsystem.setIntakeSpeed(-IntakeConstants.INTAKING_SPEED))
         .withName("Reverse Intake");
   }

   public static Command StopIntake(IntakeSubsystem intakeSubsystem) {
     return new InstantCommand(() -> intakeSubsystem.setIntakeSpeed(0)).withName("Stop Intake");
   }
