using PracticaAdivinanza.Logica;


    
    {
        
        Console.WriteLine("Ingrese el número máximo:");
        int numeroMaximo = int.Parse(Console.ReadLine());

        
        Adivinanza juego = new Adivinanza(numeroMaximo);

        Console.WriteLine("Ya elegí un número. ¡Adivina!");

        bool adivinado = false;

       
        while (!adivinado)
        {
           
            int intentoUsuario = int.Parse(Console.ReadLine());

           
            string resultado = juego.EvaluarIntento(intentoUsuario);
            Console.WriteLine(resultado);

           
            adivinado = juego.Adivinado(intentoUsuario);
        }
    }
