# MemeMe App
## Description
Udacity iOS Developer Nanodegree - 2th project - UIKit Fundamentals<br>
MemeMe lets you create meme easily by selecting existing images from your gallery or adding new ones from your camera.
## App content
This project aimed at introducing Udacity students with UIKit fundamentals such as:
- Constraints and AutoLayout (reinforce basic introduction from project one)
- UITextFields and their delegate methods to allow users to customize the meme texts
- an UIImagePickerController and its delegate methods to select files from the phone or from the camera
- an ActivityViewController to allow users to share their memes (eg: on Twitter) once created
- a TabBarController which displays both a CollectionView and a TableView for all the memes created

## Additional infos
Each meme is a simple `struct` object, which definition is location in the `MemeEditorViewController` file.<br>
The memes are not persisted within the app for this project. <br>
The memes are stored in a simple array located in the AppDelegate.
