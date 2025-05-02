import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfissionalHomePage extends StatelessWidget {
  const ProfissionalHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1), // Cor de fundo
      body: Stack(
        children: [
          // Custom Scroll View with the main content
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CircleAvatar with a placeholder
                      CircleAvatar(
                        radius: 25, // Tamanho do círculo
                        backgroundColor:
                            Colors
                                .grey[300], // Cor de fundo enquanto a imagem não carrega
                        backgroundImage: AssetImage(
                          'assets/images/doctor_image.png',
                        ), // Aqui você pode carregar a imagem do usuário
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/doctor_image.png', // Caminho da imagem
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello Jhon,',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'How\'re you today?',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: Colors.blue,
                          size: 30,
                        ),
                        onPressed: () {
                          // Ação quando o ícone for pressionado
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search health issues...',
                      labelStyle: GoogleFonts.poppins(fontSize: 13),
                      hintStyle: GoogleFonts.poppins(fontSize: 13),
                      prefixIcon: Icon(Icons.search),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              // Consults Today
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Consultas de Hoje',
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '9 de 12 completadas',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Consult Days and Symptoms/Prevention info cards
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      // Row for Consult Days
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(12, (index) {
                          return ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              backgroundColor:
                                  index == 9 ? Colors.blue : Colors.grey,
                              fixedSize: Size(30, 30),
                            ),
                            child: Text((index + 1).toString()),
                          );
                        }),
                      ),
                      SizedBox(height: 20),
                      // Symptoms and Prevention Cards
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InfoCard(
                            title: 'Symptoms',
                            description: 'Signs identify the risk of infection',
                            icon: Icons.coronavirus,
                            color: Colors.orange,
                          ),
                          InfoCard(
                            title: 'Prevention',
                            description: 'Help you avoid the risk of infection',
                            icon: Icons.health_and_safety,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Reports and Other Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InfoCard(
                            title: 'Reports',
                            description: 'Data related to the disease',
                            icon: Icons.report,
                            color: Colors.purple,
                          ),
                          InfoCard(
                            title: 'Countries',
                            description: 'Infected countries by COVID-19',
                            icon: Icons.public,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const InfoCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      height: 165,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional(0, 1),
            child: Container(
              width: 165,
              height: 136,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.5), color],
                  stops: [0, 1],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 46, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0, -1),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Icon(icon, color: color, size: 26),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
