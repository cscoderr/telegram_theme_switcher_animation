# telegram_dark_mode_animation

A new Flutter project.

- Required variables
- colorScheme
- overlay1: snapshot image
- overlay2: snapshot image
active: boolean
statusBarStyle: ColorName

- Steps:
- 0: Mark the transition as active
- 1: Take view snapshot of the light mode
- 2: wait for overlay to be displayed and switch to dark mode
- 3: Take view snapshot of the dark mode 
- 4: Animation Transition
- 5: Mark transition as inactive and remove overlay