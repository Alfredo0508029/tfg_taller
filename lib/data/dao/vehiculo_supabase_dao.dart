import 'package:supabase_flutter/supabase_flutter.dart';
import '../modelos/vehiculo.dart';

/// Objeto de Acceso a Datos (DAO - Data Access Object) responsable de gestionar
/// todas las operaciones directas contra la tabla 'vehiculos' en la base de datos Supabase.
/// Contiene las funciones CRUD (Crear, Leer, Actualizar, Borrar) y encapsula 
/// la complejidad de la conexión de red, de forma que el resto de la App no sepa qué es Supabase.
class VehiculoSupabaseDao {
  /// Obtiene una instancia siempre lista y viva del cliente oficial de Supabase.
  SupabaseClient get _client => Supabase.instance.client;

  /// Envía una petición `INSERT` a la nube para guardar un nuevo coche.
  /// Previamente inyecta (por seguridad) el Identificador de Usuario ('usuario_id')
  /// basándose en la sesión de autenticación actual, cumpliendo estrictamente
  /// con las políticas de Row Level Security (RLS) habilitadas en el panel.
  Future<void> insertar(Vehiculo vehiculo) async {
    final mapa = vehiculo.aSupabase();
    mapa['usuario_id'] = _client.auth.currentUser?.id;
    await _client.from('vehiculos').insert(mapa);
  }

  /// Ejecuta una consulta `SELECT * FROM vehiculos` para traer a memoria todos
  /// los coches registrados por el usuario que tiene la sesión abierta.
  /// (Supabase filtra en el servidor automáticamente a los demás usuarios por el RLS).
  /// Los ordena primero por 'marca' y secundariamente por 'modelo'.
  Future<List<Vehiculo>> obtenerTodos() async {
    final datos = await _client
        .from('vehiculos')
        .select()
        .order('marca')
        .order('modelo');
    return datos.map((m) => Vehiculo.desdeSupabase(m)).toList();
  }

  /// Ejecuta una consulta SQL filtrada `SELECT * ... WHERE matricula = x LIMIT 1`.
  /// Busca de forma exclusiva un único coche. Si intenta buscar una matrícula que 
  /// no existe o que pertenece a otro usuario, la API devolverá limpiamente un `null`.
  Future<Vehiculo?> obtenerPorMatricula(String matricula) async {
    final datos = await _client
        .from('vehiculos')
        .select()
        .eq('matricula', matricula)
        .maybeSingle();
    if (datos == null) return null;
    return Vehiculo.desdeSupabase(datos);
  }

  /// Envía un comando `UPDATE` que sobrescribe los datos antiguos de un coche concreto.
  /// El filtro `eq()` asegura que la actualización solo ocurre donde la columna
  /// 'matricula' coincida en la celda exacta de la tabla de PostgreSQL.
  Future<void> actualizar(Vehiculo vehiculo) async {
    await _client
        .from('vehiculos')
        .update(vehiculo.aSupabase())
        .eq('matricula', vehiculo.matricula!);
  }

  /// Variante ultraligera del método 'actualizar()'. En lugar de mandar un objeto pesado
  /// y reescribir docenas de columnas, envía un UPDATE minúsculo cambiando **únicamente**
  /// la columna del kilometraje. Promueve un gran ahorro de ancho de banda y velocidad.
  Future<void> actualizarKilometraje(String matricula, int nuevoKm) async {
    await _client
        .from('vehiculos')
        .update({'kilometraje_actual': nuevoKm})
        .eq('matricula', matricula);
  }

  /// Dispara la sentencia `DELETE` que exterminará el coche por completo.
  /// IMPORTANTE: Gracias a la configuración `ON DELETE CASCADE` de la base de datos,
  /// borrar este vehículo provocará que el propio motor SQL elimine instantáneamente
  /// todos sus componentes y el historial de mantenimiento sin dejar "registros fantasma".
  Future<void> eliminar(String matricula) async {
    await _client.from('vehiculos').delete().eq('matricula', matricula);
  }
}
