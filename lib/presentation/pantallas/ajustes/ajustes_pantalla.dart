import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tfg_taller/l10n/app_localizations.dart';

import '../../../providers/ajustes_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Pantalla global de ajustes (idioma y tema).
class AjustesPantalla extends ConsumerWidget {
  const AjustesPantalla({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estadoAjustes = ref.watch(ajustesProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          // Sección: Apariencia
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.appearance,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SwitchListTile(
            title: Text(l10n.darkMode),
            subtitle: Text(
              estadoAjustes.modoOscuro ? l10n.darkMode : l10n.lightMode,
            ),
            secondary: Icon(
              estadoAjustes.modoOscuro ? Icons.dark_mode : Icons.light_mode,
            ),
            value: estadoAjustes.modoOscuro,
            onChanged: (valor) {
              ref.read(ajustesProvider.notifier).cambiarTema(valor);
            },
          ),

          const Divider(),

          // Sección: Idioma
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.language,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonFormField<String>(
              initialValue: estadoAjustes.idioma,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.language),
              ),
              items: [
                DropdownMenuItem(value: 'es', child: Text(l10n.spanish)),
                DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                DropdownMenuItem(value: 'fr', child: Text(l10n.french)),
                DropdownMenuItem(value: 'pt', child: Text(l10n.portuguese)),
                DropdownMenuItem(value: 'it', child: Text(l10n.italian)),
                DropdownMenuItem(value: 'de', child: Text(l10n.german)),
              ],
              onChanged: (valor) {
                if (valor != null) {
                  ref.read(ajustesProvider.notifier).cambiarIdioma(valor);
                }
              },
            ),
          ),

          const Divider(),

          // Acerca de
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Taller Personal v1.0.0',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('TFG DAM', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          
          const Divider(),

          // Cerrar Sesión
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                // GoRouter will automatically redirect to /login due to the refreshListenable
              },
              icon: const Icon(Icons.logout),
              label: Text(l10n.logout),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
