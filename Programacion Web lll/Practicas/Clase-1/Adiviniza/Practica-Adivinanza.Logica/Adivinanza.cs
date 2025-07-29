namespace PracticaAdivinanza.Logica
{
    public class Adivinanza
    {
        private int numeroElegido;
        private int intentos;

        public Adivinanza(int numeroMaximo)
        {
            Random random = new Random();
            numeroElegido = random.Next(1, numeroMaximo + 1);
            intentos = 0;
        }

        public string EvaluarIntento(int intentoUsuario)
        {
            intentos++;
            int diferencia = Math.Abs(numeroElegido - intentoUsuario);

            if (intentoUsuario == numeroElegido)
            {
                return $"¡Muy bien! Has adivinado el número {numeroElegido} en {intentos} intentos.";
            }
            else if (diferencia >= 20)
            {
                return "Frio";
            }
            else if (diferencia >= 10)
            {
                return "Tibio";
            }
            else if (diferencia >= 5)
            {
                return "Caliente";
            }
            else
            {
                return "Ardiente";
            }
        }

        public bool Adivinado(int intentoUsuario)
        {
            return intentoUsuario == numeroElegido;
        }
    }
}
