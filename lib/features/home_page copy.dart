// // ignore_for_file: use_build_context_synchronously

// import 'dart:io';

// import 'package:flutter/material.dart';

// //Packages
// import 'package:filesystem_picker/filesystem_picker.dart';
// import 'package:kevents/models/csv_data.dart';
// import 'package:kevents/features/add_mkid_page.dart';

// //Shared Preferences
// import 'package:shared_preferences/shared_preferences.dart';

// //Pages

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String? path;
//   String? _filePath; //Selected File Path
//   bool isFileSelected = false; //File Selected or Not

//   final TextEditingController _fileNameController = TextEditingController();

//   //Initial Preferences
//   void _loadPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       isFileSelected = (prefs.getBool('fileSelected') ?? false);
//       _filePath = prefs.getString('filePath');
//     });
//   }

//   //Folder Picker
//   void _folderPicker() async {
//     Directory rootPath = Directory('/storage/emulated/0');
//     path = await FilesystemPicker.open(
//       title: 'Save to folder',
//       context: context,
//       theme: const FilesystemPickerTheme(
//         backgroundColor: Colors.white,
//       ),
//       rootDirectory: rootPath,
//       fsType: FilesystemType.folder,
//       pickText: 'Save file to this folder',
//     );

//     print(path);
//   }

//   //Save File
//   void _saveFile() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     //Header Text In CSV File
//     // List<List<dynamic>> header = [
//     //   ['Team ID', 'K!D', 'MKID', 'Name', 'EMail', 'Phone', 'College'],
//     // ];

//     String fileName = _fileNameController.text;
//     print(fileName);
//     final String filePath = '$path/$fileName.csv';
//     print(filePath);
//     final File file = File(filePath);
//     var result = await fileExists(filePath);
//     if (result == true) {
//       print('File already exists');
//     } else {
//       print('File does not exist');
//       file.createSync();
//     }
//     setState(() {
//       prefs.setBool('fileSelected', true);
//       prefs.setString('filePath', filePath);
//       prefs.setInt('teamNo', 1);
//       _filePath = prefs.getString('filePath');
//       isFileSelected = (prefs.getBool('fileSelected') ?? false);
//     });
//     _fileNameController.clear();
//     FocusScope.of(context).unfocus();
//   }

//   void _clearPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       prefs.setBool('fileSelected', false);
//       prefs.setString('filePath', '');
//       _filePath = prefs.getString('filePath');
//       isFileSelected = prefs.getBool('fileSelected')!;
//       prefs.setInt('teamNo', 1);
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadPreferences();
//   }

//   @override
//   Widget build(BuildContext context) {
//     //When 'No File is Selected'
//     var children1 = [
//       ElevatedButton(
//         onPressed: () {
//           _folderPicker();
//         },
//         child: const Text('Select Folder'),
//       ),
//       const SizedBox(
//         width: 10.0,
//       ),
//       ElevatedButton(
//         onPressed: () {
//           _saveFile();
//         },
//         child: const Text('Save File'),
//       ),
//       const SizedBox(
//         width: 10.0,
//       ),
//     ];

//     //When a 'File has been Selected'
//     var children2 = [
//       ElevatedButton(
//         onPressed: () {
//           _clearPreferences();
//         },
//         child: const Text('Clear'),
//       ),
//     ];

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 25.0,
//           ),
//           Text(
//             isFileSelected ? 'File Selected' : 'No File Selected',
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 20.0,
//               vertical: 10.0,
//             ),
//             child: !isFileSelected ? customTextField() : const Text(''),
//           ),
//           isFileSelected ? Text('File Path : $_filePath') : const Text(''),
//           const SizedBox(
//             height: 25.0,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               ...!isFileSelected ? children1 : children2,
//             ],
//           ),
//           const SizedBox(
//             height: 25.0,
//           ),
//           isFileSelected
//               ? ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => const QRScanner(),
//                     ));
//                   },
//                   child: const Text('Scan QR'),
//                 )
//               : const Text(''),
//           isFileSelected
//               ? ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => const MKIDPage(),
//                     ));
//                   },
//                   child: const Text('Add mK!ID'),
//                 )
//               : const Text(''),
//         ],
//       ),
//     );
//   }

//   TextField customTextField() {
//     return TextField(
//       controller: _fileNameController,
//       decoration: const InputDecoration(
//         hintText: 'Enter the file name',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.all(
//             Radius.circular(10.0),
//           ),
//         ),
//       ),
//     );
//   }
// }
