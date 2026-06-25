import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const InterviewPrepApp());
}

class InterviewPrepApp extends StatelessWidget {
  const InterviewPrepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InterviewPrep AI',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedRole = "Software Engineer";
  String selectedDifficulty = "Easy";

  final List<String> roles = [
    "Software Engineer",
    "Frontend Developer",
    "Backend Developer",
    "Full Stack Developer",
    "Flutter Developer",
    "Android Developer",
    "iOS Developer",
    "Python Developer",
    "Java Developer",
    "C++ Developer",
    "Data Analyst",
    "Data Scientist",
    "Machine Learning Engineer",
    "AI Engineer",
    "DevOps Engineer",
    "Cloud Engineer",
    "AWS Engineer",
    "Cybersecurity Analyst",
    "Ethical Hacker",
    "Network Engineer",
    "Database Administrator",
    "QA Engineer",
    "Test Engineer",
    "UI/UX Designer",
    "Blockchain Developer",
    "Game Developer",
    "Embedded Systems Engineer",
    "Site Reliability Engineer",
    "System Administrator",
    "Business Analyst",
    "Product Manager",
  ];

  List technicalQuestions = [];
  List hrQuestions = [];

  bool loading = false;

  Future<void> fetchQuestions() async {
    setState(() {
      loading = true;
      technicalQuestions = [];
      hrQuestions = [];
    });

    try {
      final url =
          "http://127.0.0.1:8000/questions?role=$selectedRole&difficulty=$selectedDifficulty";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          technicalQuestions =
              data["technical_questions"] ?? [];
          hrQuestions =
              data["hr_questions"] ?? [];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
          ),
        );
      }
    }

    setState(() {
      loading = false;
    });
  }

  Widget buildQuestionCard(String question) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.help_outline),
        title: Text(question),
      ),
    );
  }

  Widget sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 28),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: const Text(
          "InterviewPrep AI",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.work_outline,
                      size: 60,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Prepare for Your Interview",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: const InputDecoration(
                        labelText: "Select Job Role",
                        border: OutlineInputBorder(),
                      ),
                      items: roles.map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField<String>(
                      value: selectedDifficulty,
                      decoration: const InputDecoration(
                        labelText: "Select Difficulty",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Easy",
                          child: Text("Easy"),
                        ),
                        DropdownMenuItem(
                          value: "Medium",
                          child: Text("Medium"),
                        ),
                        DropdownMenuItem(
                          value: "Hard",
                          child: Text("Hard"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedDifficulty = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: loading
                            ? null
                            : fetchQuestions,
                        icon: const Icon(Icons.quiz),
                        label: const Text(
                          "Generate Questions",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            if (loading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text(
                      "Generating Questions...",
                    ),
                  ],
                ),
              ),

            if (!loading &&
                technicalQuestions.isEmpty &&
                hrQuestions.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Select a role and difficulty, then generate questions.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

            if (technicalQuestions.isNotEmpty) ...[
              sectionTitle(
                "Technical Questions",
                Icons.computer,
              ),

              const SizedBox(height: 10),

              ...technicalQuestions.map(
                (q) => buildQuestionCard(
                  q.toString(),
                ),
              ),
            ],

            if (hrQuestions.isNotEmpty) ...[
              const SizedBox(height: 25),

              sectionTitle(
                "HR Questions",
                Icons.people,
              ),

              const SizedBox(height: 10),

              ...hrQuestions.map(
                (q) => buildQuestionCard(
                  q.toString(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}