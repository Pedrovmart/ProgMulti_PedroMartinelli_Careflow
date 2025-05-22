import 'package:flutter/material.dart';

// Definições de Cores (aproximações do TailwindCSS)
const Color _slate50 = Color(0xFFF8FAFC);
const Color _slate200 = Color(0xFFE2E8F0);
const Color _slate400 = Color(0xFF94A3B8);
const Color _slate700 = Color(0xFF334155);
const Color _slate800 = Color(0xFF1E293B);
const Color _slate900 = Color(0xFF0F172A);

const Color _sky100 = Color(0xFFE0F2FE);
const Color _sky200 = Color(0xFFBAE6FD);
const Color _sky500 = Color(0xFF0EA5E9);
const Color _sky600 = Color(0xFF0284C7);
const Color _sky800 = Color(0xFF075985);
const Color _sky900 = Color(0xFF0C4A6E);

const Color _amber100 = Color(0xFFFEF3C7);
const Color _amber200 = Color(0xFFFDE68A);
const Color _amber800 = Color(0xFF92400E);
const Color _amber900 = Color(0xFF78350F);

const Color _white = Colors.white;

class ProfissionalAgendamentosPage extends StatelessWidget {
  const ProfissionalAgendamentosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _slate50,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: _slate50.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBwuP-lo9ZtcJc7iOj6X-wksnZIcSRorecaIW5UnKkqM0OnMhmoY-xkk-3OXzg6kkPOObNRLEb_Y50oeWzBds8eo7YuP4dfhi4tz3JRas84dQJUseeqXN-DXb7_IGE6IIBmcNYGo0UlOQgXQsr2v5umwVToOYjZjaRaeiFZiIxeHp3xchLInTrR7y7W6JvX4CQBFsU5ihSvpi6gVqY2G37W1OZ6adu0EAB3rr7u6uqylbIocSmQqoonA1QdsK79-f7W2vt-G801vPFx'),
                ),
                const SizedBox(width: 12.0),
                const Text(
                  'Olá, Dr. Silva',
                  style: TextStyle(
                    color: _slate900,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: _slate700),
              onPressed: () {},
              splashRadius: 24.0,
              padding: const EdgeInsets.all(8.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsSection(context),
            const SizedBox(height: 24.0),
            _buildUpcomingAppointmentsSection(context),
            const SizedBox(height: 24.0),
            _buildQuickActionsSection(context),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 600;

        Widget item1 = _buildStatCard(
          context: context,
          title: 'Pacientes hoje',
          value: '12',
          backgroundColor: _sky100.withOpacity(0.7),
          borderColor: _sky200,
          titleColor: _sky800,
          valueColor: _sky900,
        );
        Widget item2 = _buildStatCard(
          context: context,
          title: 'Consultas',
          value: '8',
          backgroundColor: _sky100.withOpacity(0.7),
          borderColor: _sky200,
          titleColor: _sky800,
          valueColor: _sky900,
        );
        Widget item3 = _buildStatCard(
          context: context,
          title: 'Notificações',
          value: '3',
          backgroundColor: _amber100.withOpacity(0.7),
          borderColor: _amber200,
          titleColor: _amber800,
          valueColor: _amber900,
        );

        if (isWide) {
          return GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: (constraints.maxWidth / 3) / 110, // Ajustar altura do card
            children: [item1, item2, item3],
          );
        } else {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: item1),
                  const SizedBox(width: 12.0),
                  Expanded(child: item2),
                ],
              ),
              const SizedBox(height: 12.0),
              SizedBox(
                width: double.infinity,
                child: item3,
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required Color backgroundColor,
    required Color borderColor,
    required Color titleColor,
    required Color valueColor,
  }) {
    return Container(
      height: 100, // Dar uma altura fixa para consistência
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3.0,
            offset: const Offset(0, 1),
          )
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingAppointmentsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(4.0, 0, 4.0, 12.0),
          child: Text(
            'Próximos compromissos',
            style: TextStyle(
              color: _slate800,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _buildAppointmentItem(
          context: context,
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAKF6rkXdBXJ4B7HrcQqkfPwBkvgPQVxmVZ5YkUfMAL17CxDjJ2ue_Xn9Cu-AUNIkogQILX4E9peoxO9EboDlcrFuj8HV50bVhu4Jqb07yTzcOeaUfQHTssbqsqGI7-icZ46_6lcettz5BUQILDmWKVvlf_3Id_7unXrG2wz29WWU70NNn-Udgtiyx4z4-fHz-XKIfVEFULyoFK_YeZFzU1tHso-rRcWQA8sKWmCtVg0ElOPOC-eGaL988AOSAG4c7iXM3s__OKo-f9',
          name: 'Consulta com Maria Souza',
          time: '10:00 - 10:30',
        ),
        const SizedBox(height: 12.0),
        _buildAppointmentItem(
          context: context,
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAAQBpZpD1npaBqR4bw3EPfFhZ78qvp7h6PAPBYaxmFk0f3-bFgjxfR4pHPdCeKXe6L0NnmKOBL1KYgCwmgh2m0u8Nu63aKi_qAO2PBeim8cTi-YhFSB9mv-07BDjYVTxdTCtjxwqYDDcXnbRQNFTzTZRdfuF0LoY0T9P7AcsV_mwzZYv9jDYt6tBRrwK9Sm6TcSWSrvuz620HFB80XN55QCg-6TjItgM5aQfSkJo_xpVQzYKzxiHoF7LqqYErHKl8PGAtPLOJyvVh2',
          name: 'Consulta com Carlos Mendes',
          time: '11:00 - 11:45',
        ),
        const SizedBox(height: 12.0),
        _buildAppointmentItem(
          context: context,
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDdaNby_F915T3Z9oYsD1A7_DVdbHqQ6F-_fn_616WpW6nakjfO1hnFhVOOnikWrFTWTiDanjOMD5mHActITc3YUY1riXdNtpC5p4cu0iEoThpSJFPQIQvmhfPsIbAHFbcQQjddHG-kypAgfqTykaQ7b45lCvTJY_8gv657zWWHFjaXz4uy0ki2PFHLOPBCZJ4MbDX_N9X_zTX6N9upVVs0n59wyTHTrPb6OhJpeAV5sjhPsmV0LfyPItErv5eYI0LF-wwQ1-FwMzyX',
          name: 'Consulta com Ana Pereira',
          time: '13:00 - 13:30',
        ),
      ],
    );
  }

  Widget _buildAppointmentItem({
    required BuildContext context,
    required String imageUrl,
    required String name,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: _slate200, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3.0,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.0,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: _slate900,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    color: _sky600,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_outlined, color: _slate400),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 12.0),
          child: Text(
            'Ações rápidas',
            style: TextStyle(
              color: _slate800,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                context: context,
                icon: Icons.search_rounded,
                label: 'Buscar paciente',
                backgroundColor: _sky500,
                foregroundColor: _white,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: _buildQuickActionButton(
                context: context,
                icon: Icons.add_circle_outline_rounded,
                label: 'Novo agendamento',
                backgroundColor: _slate200,
                foregroundColor: _slate800,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      height: 112,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 2.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30.0),
            const SizedBox(height: 8.0),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
