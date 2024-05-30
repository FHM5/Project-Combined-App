import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioMaker extends StatefulWidget {
  @override
  _PortfolioMakerState createState() => _PortfolioMakerState();
}

class _PortfolioMakerState extends State<PortfolioMaker> {
  File? _image;
  File? _resume;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _contactController = TextEditingController();
  final _projectTitleController = TextEditingController();
  final _projectDescriptionController = TextEditingController();
  final _projectLinkController = TextEditingController();
  final _articleTitleController = TextEditingController();
  final _articleContentController = TextEditingController();
  final _socialMediaLinkController = TextEditingController();
  final _achievementTitleController = TextEditingController();
  final _achievementDescriptionController = TextEditingController();
  List<Map<String, String>> _projects = [];
  List<Map<String, String>> _articles = [];
  List<String> _socialMediaLinks = [];
  List<Map<String, String>> _achievements = [];
  List<Map<String, dynamic>> _savedPortfolios = [];

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    setState(() {
      if (result != null) {
        _resume = File(result.files.single.path!);
      }
    });
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _savePortfolio() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _savedPortfolios.add({
          'name': _nameController.text,
          'bio': _bioController.text,
          'contact': _contactController.text,
          'projects': List.from(_projects),
          'articles': List.from(_articles),
          'socialMediaLinks': List.from(_socialMediaLinks),
          'achievements': List.from(_achievements),
        });

        // Clear the form fields and lists
        _nameController.clear();
        _bioController.clear();
        _contactController.clear();
        _projects.clear();
        _articles.clear();
        _socialMediaLinks.clear();
        _achievements.clear();
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _contactController.dispose();
    _projectTitleController.dispose();
    _projectDescriptionController.dispose();
    _projectLinkController.dispose();
    _articleTitleController.dispose();
    _articleContentController.dispose();
    _socialMediaLinkController.dispose();
    _achievementTitleController.dispose();
    _achievementDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Portfolio Maker'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _savePortfolio,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(Icons.add_a_photo, size: 50, color: Colors.white)
                      : null,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[900],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  labelStyle: TextStyle(color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[900],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a bio';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(
                  labelText: 'Contact',
                  labelStyle: TextStyle(color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[900],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact information';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // background color
                  foregroundColor: Colors.black, // text color
                ),
                onPressed: _pickResume,
                child: Text('Upload Resume/CV'),
              ),
              if (_resume != null) ...[
                SizedBox(height: 10),
                Text(
                  'Resume: ${_resume!.path.split('/').last}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
              SizedBox(height: 20),
              Text(
                'Projects',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ..._projects.map((project) {
                return Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    title: Text(project['title']!,
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(project['description']!,
                        style: TextStyle(color: Colors.white70)),
                    trailing: IconButton(
                      icon: Icon(Icons.launch, color: Colors.blueAccent),
                      onPressed: () => _launchURL(project['link']!),
                    ),
                  ),
                );
              }).toList(),
              SizedBox(height: 20),
              TextFormField(
                controller: _projectTitleController,
                decoration: InputDecoration(
                  labelText: 'Project Title',
                  labelStyle: TextStyle(color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[900],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _projectDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Project Description',
                  labelStyle: TextStyle(color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[900],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _projectLinkController,
                decoration: InputDecoration(
                  labelText: 'Project Link',
                  labelStyle: TextStyle(color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[900],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // background color
                  foregroundColor: Colors.black, // text color
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _projects.add({
                        'title': _projectTitleController.text,
                        'description': _projectDescriptionController.text,
                        'link': _projectLinkController.text,
                      });
                      _projectTitleController.clear();
                      _projectDescriptionController.clear();
                      _projectLinkController.clear();
                    });
                  }
                },
                child: Text('Add Project'),
              ),
              SizedBox(height: 20),
              Text(
                'Social Media Links',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ..._socialMediaLinks.map((link) {
                return Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    title: Text(link, style: TextStyle(color: Colors.white)),
                    trailing: IconButton(
                      icon: Icon(Icons.launch, color: Colors.blueAccent),
                      onPressed: () => _launchURL(link),
                    ),
                  ),
                );
              }).toList(),
              SizedBox(height: 20),
              TextFormField(
                controller: _socialMediaLinkController,
                decoration: InputDecoration(
                  labelText: 'Social Media Link',
                  labelStyle: TextStyle(color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[900],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // background color
                  foregroundColor: Colors.black, // text color
                ),
                onPressed: () {
                  if (_socialMediaLinkController.text.isNotEmpty) {
                    setState(() {
                      _socialMediaLinks.add(_socialMediaLinkController.text);
                      _socialMediaLinkController.clear();
                    });
                  }
                },
                child: Text('Add Social Media Link'),
              ),
              SizedBox(height: 20),
              Text(
                'Articles',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ..._articles.map((article) {
                return Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    title: Text(article['title']!,
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(article['content']!,
                        style: TextStyle(color: Colors.white70)),
                  ),
                );
              }).toList(),
              SizedBox(height: 20),
              TextFormField(
                controller: _articleTitleController,
                decoration: InputDecoration(
                  labelText: 'Article Title',
                  labelStyle: TextStyle(color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[900],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _articleContentController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Article Content',
                  labelStyle: TextStyle(color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[900],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // background color
                  foregroundColor: Colors.black, // text color
                ),
                onPressed: () {
                  if (_articleTitleController.text.isNotEmpty &&
                      _articleContentController.text.isNotEmpty) {
                    setState(() {
                      _articles.add({
                        'title': _articleTitleController.text,
                        'content': _articleContentController.text,
                      });
                      _articleTitleController.clear();
                      _articleContentController.clear();
                    });
                  }
                },
                child: Text('Add Article'),
              ),
              SizedBox(height: 20),
              Text(
                'Achievements and Certifications',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ..._achievements.map((achievement) {
                return Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    title: Text(achievement['title']!,
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(achievement['description']!,
                        style: TextStyle(color: Colors.white70)),
                  ),
                );
              }).toList(),
              SizedBox(height: 20),
              TextFormField(
                controller: _achievementTitleController,
                decoration: InputDecoration(
                  labelText: 'Achievement/Certification Title',
                  labelStyle: TextStyle(color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[900],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _achievementDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Achievement/Certification Description',
                  labelStyle: TextStyle(color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[900],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // background color
                  foregroundColor: Colors.black, // text color
                ),
                onPressed: () {
                  if (_achievementTitleController.text.isNotEmpty &&
                      _achievementDescriptionController.text.isNotEmpty) {
                    setState(() {
                      _achievements.add({
                        'title': _achievementTitleController.text,
                        'description': _achievementDescriptionController.text,
                      });
                      _achievementTitleController.clear();
                      _achievementDescriptionController.clear();
                    });
                  }
                },
                child: Text('Add Achievement/Certification'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // background color
                  foregroundColor: Colors.black, // text color
                ),
                onPressed: _savePortfolio,
                child: Text('Save Portfolio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
