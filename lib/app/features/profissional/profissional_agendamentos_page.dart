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
    // Para usar fontes personalizadas como Manrope, adicione-as ao pubspec.yaml e à pasta de assets.
    return Scaffold(
      backgroundColor: _slate50,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Remove o botão de voltar padrão se não for necessário
      backgroundColor: _slate50.withOpacity(0.8), // Similar a bg-slate-50/80
      elevation: 0, // Remove a sombra padrão, o HTML usa backdrop-blur
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0), // p-4 pb-2
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20, // size-10 / 2
                  backgroundImage: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBwuP-lo9ZtcJc7iOj6X-wksnZIcSRorecaIW5UnKkqM0OnMhmoY-xkk-3OXzg6kkPOObNRLEb_Y50oeWzBds8eo7YuP4dfhi4tz3JRas84dQJUseeqXN-DXb7_IGE6IIBmcNYGo0UlOQgXQsr2v5umwVToOYjZjaRaeiFZiIxeHp3xchLInTrR7y7W6JvX4CQBFsU5ihSvpi6gVqY2G37W1OZ6adu0EAB3rr7u6uqylbIocSmQqoonA1QdsK79-f7W2vt-G801vPFx'),
                ),
                const SizedBox(width: 12.0), // gap-3
                const Text(
                  'Olá, Dr. Silva',
                  style: TextStyle(
                    color: _slate900,
                    fontSize: 20.0, // text-xl
                    fontWeight: FontWeight.bold, // font-bold
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: _slate700),
              onPressed: () {},
              splashRadius: 24.0,
              padding: const EdgeInsets.all(8.0), // p-2
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0), // main p-4
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsSection(context),
            const SizedBox(height: 24.0), // mb-6
            _buildUpcomingAppointmentsSection(context),
            const SizedBox(height: 24.0), // mb-6
            _buildQuickActionsSection(context),
            const SizedBox(height: 16.0), // Espaço extra no final
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 600; // sm breakpoint
        int crossAxisCount = isWide ? 3 : 2;
        double childAspectRatio = isWide ? (constraints.maxWidth / 3 / 100) : (constraints.maxWidth / 2 / 100);
        if (childAspectRatio < 1.2) childAspectRatio = 1.2;
        if (childAspectRatio > 1.8 && !isWide) childAspectRatio = 1.8;
        if (childAspectRatio > 2.0 && isWide) childAspectRatio = 2.0;


        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12.0, // gap-3
          mainAxisSpacing: 12.0, // gap-3
          childAspectRatio: childAspectRatio, 
          children: [
            _buildStatCard(
              context: context,
              title: 'Pacientes hoje',
              value: '12',
              backgroundColor: _sky100.withOpacity(0.7),
              borderColor: _sky200,
              titleColor: _sky800,
              valueColor: _sky900,
            ),
            _buildStatCard(
              context: context,
              title: 'Consultas',
              value: '8',
              backgroundColor: _sky100.withOpacity(0.7),
              borderColor: _sky200,
              titleColor: _sky800,
              valueColor: _sky900,
            ),
            _buildStatCard(
              context: context,
              title: 'Notificações',
              value: '3',
              backgroundColor: _amber100.withOpacity(0.7),
              borderColor: _amber200,
              titleColor: _amber800,
              valueColor: _amber900,
              fullSpan: !isWide, // Ocupa 2 colunas se não for wide
            ),
          ],
        );
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
    bool fullSpan = false, // Para o GridView
  }) {
    final cardContent = Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0), // rounded-xl
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3.0,
            offset: const Offset(0, 1),
          )
        ],
      ),
      padding: const EdgeInsets.all(16.0), // p-4
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 14.0, // text-sm
              fontWeight: FontWeight.w500, // font-medium
            ),
          ),
          const SizedBox(height: 4.0), // gap-1
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 30.0, // text-3xl
              fontWeight: FontWeight.bold, // font-bold
              letterSpacing: -0.5, // tracking-tight (aproximação)
            ),
          ),
        ],
      ),
    );
    if (fullSpan) {
        return GridTile(child: cardContent); // Ocupa o espaço que o GridView designar
    }
    return cardContent;
  }

  Widget _buildUpcomingAppointmentsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(4.0, 0, 4.0, 12.0), // px-1 pb-3
          child: Text(
            'Próximos compromissos',
            style: TextStyle(
              color: _slate800,
              fontSize: 18.0, // text-lg
              fontWeight: FontWeight.w600, // font-semibold
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
        const SizedBox(height: 12.0), // space-y-3
        _buildAppointmentItem(
          context: context,
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAAQBpZpD1npaBqR4bw3EPfFhZ78qvp7h6PAPBYaxmFk0f3-bFgjxfR4pHPdCeKXe6L0NnmKOBL1KYgCwmgh2m0u8Nu63aKi_qAO2PBeim8cTi-YhFSB9mv-07BDjYVTxdTCtjxwqYDDcXnbRQNFTzTZRdfuF0LoY0T9P7AcsV_mwzZYv9jDYt6tBRrwK9Sm6TcSWSrvuz620HFB80XN55QCg-6TjItgM5aQfSkJo_xpVQzYKzxiHoF7LqqYErHKl8PGAtPLOJyvVh2',
          name: 'Consulta com Carlos Mendes',
          time: '11:00 - 11:45',
        ),
        const SizedBox(height: 12.0), // space-y-3
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
      padding: const EdgeInsets.all(12.0), // p-3
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(12.0), // rounded-xl
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
            radius: 24.0, // size-12 / 2
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(width: 16.0), // gap-4
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: _slate900,
                    fontSize: 16.0, // text-base
                    fontWeight: FontWeight.w500, // font-medium
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    color: _sky600,
                    fontSize: 14.0, // text-sm
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
          padding: EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 12.0), // px-1 pt-2 pb-3
          child: Text(
            'Ações rápidas',
            style: TextStyle(
              color: _slate800,
              fontSize: 18.0, // text-lg
              fontWeight: FontWeight.w600, // font-semibold
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
            const SizedBox(width: 12.0), // gap-3
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
      height: 112, // h-28 (28 * 4.0)
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: const EdgeInsets.all(16.0), // p-4
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // rounded-xl
          ),
          elevation: 2.0, // shadow-sm (aproximação)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30.0), // text-3xl (aproximação para ícone)
            const SizedBox(height: 8.0), // gap-2
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.0, // text-sm
                fontWeight: FontWeight.w600, // font-semibold
              ),
            ),
          ],
        ),
      ),
    );
  }
}
