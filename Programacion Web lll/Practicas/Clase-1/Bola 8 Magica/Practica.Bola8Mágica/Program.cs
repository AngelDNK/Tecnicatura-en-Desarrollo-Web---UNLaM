using PracticaBola8Magica.Logica;
{



    var bola8Magica = new Bola8Magica();




    Console.WriteLine("Bienvenido al juego de la Bola 8 Mágica!\n");

    while (true)
    {
        
        Console.WriteLine("Escribe una pregunta:");
        string pregunta = Console.ReadLine(); //PARA ESCRIBIR POR CONSOLA

        
        if (pregunta.ToLower() == "salir")
        {
            Console.WriteLine("¡Hasta luego!");
            break;
        }

       
        string respuestaAleatoria = bola8Magica.ObtenerRespuestaAleatoria();

        
        Console.WriteLine("La Bola 8 Mágica dice: " + respuestaAleatoria + "\n");

    }
}
