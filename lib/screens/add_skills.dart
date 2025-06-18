import 'package:flutter/material.dart';

class addSkills extends StatefulWidget {
  const addSkills({super.key});

  @override
  State<addSkills> createState() => _addSkillsState();
}

class _addSkillsState extends State<addSkills> {

  final _formkey = GlobalKey<FormState>();
  String skillName = "";
  String description = "";
  int goalHours = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Skill"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(label: Text("Skill Name")),
                validator: (value){
                  if(value!.isEmpty){
                    return "Please enter a skill name";
                  }

                  return null;
                },
                onSaved: (value)=> skillName = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(label: Text("Description")),
                onSaved: (value)=> description = value ?? '',
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(label: Text("Goal Hours")),
                keyboardType: TextInputType.number,
                validator: (value){
                  if(value ==null || value!.isEmpty){
                    return "Please enter goal hours";
                  }

                  if(int.tryParse(value) == null || int.parse(value) <= 0){
                    return "Please enter a valid number";
                  }
                  return null;
                },
                onSaved: (value){
                  if(value!=null && value.isNotEmpty){
                    goalHours=int.tryParse(value) ?? 0;
                  }else{
                    goalHours = 0;
                  }
                },
                
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: (){
                  if(_formkey.currentState!.validate()){
                    _formkey.currentState!.save();
                    Navigator.pop(context, {
                      'skillName': skillName,
                      'description': description,
                      'goalHours': goalHours,
                    });
                  }
                },

                child: Text("Add Skill"),
              )
          
            ],
          ),
        ),
      ),
    );
  }
}