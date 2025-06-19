// import 'package:flutter/material.dart';

// class addSkills extends StatefulWidget {
//   const addSkills({super.key});

//   @override
//   State<addSkills> createState() => _addSkillsState();
// }

// class _addSkillsState extends State<addSkills> {

//   final _formkey = GlobalKey<FormState>();
//   String skillName = "";
//   String description = "";
//   int goalHours = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add Skill"),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formkey,
//           child: Column(
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(label: Text("Skill Name")),
//                 validator: (value){
//                   if(value!.isEmpty){
//                     return "Please enter a skill name";
//                   }

//                   return null;
//                 },
//                 onSaved: (value)=> skillName = value!,
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 decoration: InputDecoration(label: Text("Description")),
//                 onSaved: (value)=> description = value ?? '',
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 decoration: InputDecoration(label: Text("Goal Hours")),
//                 keyboardType: TextInputType.number,
//                 validator: (value){
//                   if(value ==null || value!.isEmpty){
//                     return "Please enter goal hours";
//                   }

//                   if(int.tryParse(value) == null || int.parse(value) <= 0){
//                     return "Please enter a valid number";
//                   }
//                   return null;
//                 },
//                 onSaved: (value){
//                   if(value!=null && value.isNotEmpty){
//                     goalHours=int.tryParse(value) ?? 0;
//                   }else{
//                     goalHours = 0;
//                   }
//                 },
                
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: (){
//                   if(_formkey.currentState!.validate()){
//                     _formkey.currentState!.save();
//                     Navigator.pop(context, {
//                       'skillName': skillName,
//                       'description': description,
//                       'goalHours': goalHours,
//                     });
//                   }
//                 },

//                 child: Text("Add Skill"),
//               )
          
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class addSkills extends StatefulWidget {
  final Map<String, dynamic>? initialData; // <-- Accept initial data for edit

  const addSkills({super.key, this.initialData});

  @override
  State<addSkills> createState() => _addSkillsState();
}

class _addSkillsState extends State<addSkills> {
  
  final _formkey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _goalController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with either initialData or default values
    _nameController = TextEditingController(
        text: widget.initialData != null ? widget.initialData!['skillName'] ?? '' : '');
    _descController = TextEditingController(
        text: widget.initialData != null ? widget.initialData!['description'] ?? '' : '');
    _goalController = TextEditingController(
        text: widget.initialData != null ? widget.initialData!['goalHours'].toString() : '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.initialData != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? "Edit Skill" : "Add Skill"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(label: Text("Skill Name")),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a skill name";
                  }

                  return null;


                },

              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(label: Text("Description")),

              ),

              SizedBox(height: 16),
              TextFormField(
                controller: _goalController,
                decoration: InputDecoration(label: Text("Goal Hours")),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter goal hours";
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return "Please enter a valid number";
                  }
                  return null;

                },

              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    Navigator.pop(context, {
                      'skillName': _nameController.text.trim(),
                      'description': _descController.text.trim(),
                      'goalHours': int.parse(_goalController.text.trim()),
                    });
                  }
                },
                child: Text(isEditMode ? "Update Skill" : "Add Skill"),
              )

            ],

          ),
        ),
      ),
    );
  }
}
