import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'calculator_screen.dart';
import 'quiz_app.dart';
import 'weather_app.dart';
import 'portfolio_maker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          headline1: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 32.0,
            color: Colors.white,
          ),
          bodyText1: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16.0,
            color: Colors.white,
          ),
          button: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.grey[850],
          margin: EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: MyHomePage(),
      routes: {
        '/calculator': (context) => CalculatorScreen(),
        '/quiz': (context) => QuizApp(),
        '/weather': (context) => WeatherApp(),
        '/portfolio_maker': (context) => PortfolioMaker(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to my portfolio!',
            style: Theme.of(context).textTheme.headline1),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              ),
            ),
            Text(
              'Faisal Hasan',
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(height: 20),
            Text(
              'Flutter Developer',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 20),
            SocialMediaRow(),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'About Me',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'My name is Faisal Hasan. '
                'I\'m currently in the 8th semester, where I have learned to work with flutter. '
                'This portfolio is a showcase of the projects I have done throughout this semester using flutter. ',
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Projects',
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(height: 20),
            PortfolioButtons(),
            SizedBox(height: 40),
            ContactMe(),
          ],
        ),
      ),
    );
  }
}

class SocialMediaRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: FaIcon(FontAwesomeIcons.facebook, size: 32),
          onPressed: () => _launchURL('https://www.facebook.com/'),
        ),
        IconButton(
          icon: FaIcon(FontAwesomeIcons.instagram, size: 32),
          onPressed: () => _launchURL('https://www.instagram.com/'),
        ),
        IconButton(
          icon: FaIcon(FontAwesomeIcons.twitter, size: 32),
          onPressed: () => _launchURL('https://twitter.com/'),
        ),
        IconButton(
          icon: FaIcon(FontAwesomeIcons.linkedin, size: 32),
          onPressed: () => _launchURL('https://bd.linkedin.com/'),
        ),
        IconButton(
          icon: FaIcon(FontAwesomeIcons.github, size: 32),
          onPressed: () => _launchURL('https://github.com/FHM5'),
        ),
        IconButton(
          icon: FaIcon(FontAwesomeIcons.medium, size: 32),
          onPressed: () => _launchURL('https://medium.com/'),
        ),
      ],
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class PortfolioButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PortfolioButton(
          title: 'Quiz App',
          onPressed: () {
            Navigator.pushNamed(context, '/quiz');
          },
        ),
        PortfolioButton(
          title: 'Calculator App',
          onPressed: () {
            Navigator.pushNamed(context, '/calculator');
          },
        ),
        PortfolioButton(
          title: 'Weather App',
          onPressed: () {
            Navigator.pushNamed(context, '/weather');
          },
        ),
        PortfolioButton(
          title: 'Portfolio Maker App',
          onPressed: () {
            Navigator.pushNamed(context, '/portfolio_maker');
          },
        ),
      ],
    );
  }
}

class PortfolioButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  PortfolioButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          textStyle: Theme.of(context).textTheme.button,
        ),
      ),
    );
  }
}

class ContactMe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Get in Touch',
          style: Theme.of(context).textTheme.headline1,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ContactCard(
              icon: Icons.home,
              title: 'Location',
              subtitle: 'Dhaka, Bangladesh',
            ),
            ContactCard(
              icon: Icons.phone,
              title: 'Phone',
              subtitle: '(+880)01984302439',
            ),
            ContactCard(
              icon: Icons.email,
              title: 'Email',
              subtitle: 'hasan15-14754@diu.edu.bd',
            ),
          ],
        ),
      ],
    );
  }
}

class ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  ContactCard(
      {required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 50, color: Colors.blueAccent),
            SizedBox(height: 10),
            Text(title, style: Theme.of(context).textTheme.bodyText1),
            SizedBox(height: 5),
            Text(subtitle, style: Theme.of(context).textTheme.bodyText1),
          ],
        ),
      ),
    );
  }
}
