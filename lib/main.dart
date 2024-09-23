import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Financial Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OnboardingScreen(),  // Starting point
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  List<Widget> _buildPages() {
    return [
      _buildPage('Track Your Expenses', 'assets/page1.jpg'),
      _buildPage('Create Budgets', 'assets/page1.jpg'),
      _buildPage('Manage Your Accounts', 'assets/page1.jpg'),
    ];
  }

  Widget _buildPage(String title, String assetPath) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 20),
        // You can use an image instead of an SVG if needed.
        Image.asset(assetPath, height: 300),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _buildPages(),
      ),
      bottomSheet: _currentIndex == 2
          ? TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Get Started'),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      _pageController.jumpToPage(2);
                    },
                    child: const Text('Skip'),
                  ),
                  Row(
                    children: List.generate(
                      3,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;

  void toggleForm() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Login' : 'Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text(isLogin ? 'Login' : 'Sign Up'),
            ),
            TextButton(
              onPressed: toggleForm,
              child: Text(isLogin
                  ? "Don't have an account? Sign Up"
                  : "Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    AnalysisPage(),
    const Center(child: Text('Categories Page')),
    BudgetPage(),
    const Center(child: Text('Accounts Page')),
    const Center(child: Text('Profile Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Manager'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
  items: const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.analytics),
      label: 'Analysis',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.category),
      label: 'Categories',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_balance_wallet),
      label: 'Budgets',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_balance),
      label: 'Accounts',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ],
  currentIndex: _selectedIndex,
  onTap: _onItemTapped,
  selectedItemColor: Colors.blue, // Set the selected item color to blue
  unselectedItemColor: Colors.black, // Set the unselected item color to black
  type: BottomNavigationBarType.fixed, // Ensures that labels are always shown
),
    );
  }
}

class BudgetPage extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  int _selectedIndex = 2;
  String _selectedMonth = 'September 2024';

  final List<Map<String, dynamic>> _budgetedItems = [
    {'icon': Icons.fastfood, 'label': 'Food', 'amount': 'MK200,000'},
    {'icon': Icons.directions_bus, 'label': 'Transportation', 'amount': 'MK100,000'},
    {'icon': Icons.shopping_bag, 'label': 'Clothing', 'amount': 'MK150,000'},
  ];

  final List<Map<String, dynamic>> _notBudgetedItems = [
    {'icon': Icons.computer, 'label': 'Electronics'},
    {'icon': Icons.favorite, 'label': 'Healthy'},
    {'icon': Icons.phone_android, 'label': 'Bundles'},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'StudentBudget',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown for selecting month
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Selected month:', style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    value: _selectedMonth,
                    items: <String>['September 2024', 'October 2024', 'November 2024']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMonth = newValue!;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Budget and Expenditure Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Budget:', style: TextStyle(fontSize: 16)),
                      Text('MK450,000', style: TextStyle(fontSize: 18, color: Colors.green)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Expenditure:', style: TextStyle(fontSize: 16)),
                      Text('MK50,000', style: TextStyle(fontSize: 18, color: Colors.red)),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 30),

              // Budgeted Items
              Text('Budgeted items:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Column(
                children: _budgetedItems.map((item) {
                  return ListTile(
                    leading: Icon(item['icon'], size: 40),
                    title: Text(item['label'], style: TextStyle(fontSize: 16)),
                    trailing: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(item['amount'], style: TextStyle(fontSize: 16)),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 30),

              // Not Budgeted Items
              Text('Not budgeted items:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Column(
                children: _notBudgetedItems.map((item) {
                  return ListTile(
                    leading: Icon(item['icon'], size: 40),
                    title: Text(item['label'], style: TextStyle(fontSize: 16)),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.black),
                      ),
                      onPressed: () {},
                      child: Text('SET BUDGET', style: TextStyle(color: Colors.black)),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 20),

              // Remove Ads section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.block, size: 30, color: Colors.red),
                  SizedBox(width: 10),
                  Text('Remove Ads - MK3,500', style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.black,
        child: Icon(Icons.add, size: 40),
      ),
    );
  }
}

class AnalysisPage extends StatefulWidget {
  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  String _selectedMonth = 'September 2024';

  final List<Map<String, dynamic>> _records = [
    {'icon': Icons.fastfood, 'label': 'Food - Airtel Money', 'date': '13th September 2024', 'amount': '-MK2,000', 'color': Colors.red},
    {'icon': Icons.account_balance, 'label': 'Upkeep - National Bank', 'date': '12th September 2024', 'amount': 'MK280,000', 'color': Colors.green},
    {'icon': Icons.fastfood, 'label': 'Food - Airtel Money', 'date': '8th September 2024', 'amount': '-MK6,500', 'color': Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'StudentBudget',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Selected month:', style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    value: _selectedMonth,
                    items: <String>['September 2024', 'October 2024', 'November 2024']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMonth = newValue!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Analysis Title
              Text(
                'Analysis',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              
              SizedBox(height: 20),

              // Monthly Records
              Text(
                'Monthly records',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Column(
                children: _records.map((record) {
                  return ListTile(
                    leading: Icon(record['icon'], size: 40),
                    title: Text(record['label'], style: TextStyle(fontSize: 16)),
                    subtitle: Text(record['date'], style: TextStyle(fontSize: 14)),
                    trailing: Text(
                      record['amount'],
                      style: TextStyle(
                        fontSize: 16,
                        color: record['color'],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),

              // Remove Ads Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.block, size: 30, color: Colors.red),
                  SizedBox(width: 10),
                  Text('Remove Ads - MK3,500', style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: Icon(Icons.add, size: 40),
      ),
    );
  }

  Widget _buildLegendItem(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
