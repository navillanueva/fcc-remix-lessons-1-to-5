//LESSON 2 WELCOME TO REMIX

//SPDX-License-Identifier: MIT
//este identifier es necesario 

pragma solidity 0.8.8;

/*
pragma solidity ^0.8.7;             --> incluye todas las versiones de 0.8.7 y superiores
pragma solidity >=0.8.7 <0.9.0;     --> usa las versiones en el intervalo (0.8.7 // 0.8.8...)
*/  

contract SimpleStorage {
    /* 
    SOLIDITY TYPES 
        -boolean
            bool hasFavoriteNumber = true;

        -uint: numero entero positivo y se puede especificar el número de bytes (8, 16, 32, etc...)
            uint256 hasFavoriteNumber = 123;

        -int: tmbn se puede especificar el número de bytes y son positivos y negativos
            int256 favoriteInt = -5;
        
        -string: funcion y declaracion igual que en javascript
            string favoriteNumberInText = "Five"
        -address
            address myAddress = 0xF2B47fFD55fEC2528Ba4e630Ac4634531ad25e15;
        
        -bytes: normalmente son 0x12H124Jh1 y el maximo tamaño que pueden ser es 32
            bytes32 = favoriteBytes = "cat";
    
    */

    //0x358AA13c52544ECCEF6B0ADD0f801012ADAD5eE3       --> address del smartcontract que hemos creado

    uint256 public favoriteNumber;      //public: hacemos que se pueda ver desde fuera y dentro del contrato
                                        //private: solo es visible desde dentro del contrato
                                        //external: solo visible para fuera del contrato (hay q llamarlo con this.func)
                                        //internal: visible para dentro del contrato y los hijos del contrato
                                        //vacio: se inicializa automaticamente a internal cuando no ponemos nada

    //datastructure para relacionar variables

    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public {    //con esta funcion se cambia el valor del numero inicializado a 0
        favoriteNumber = _favoriteNumber;
        //uint256 testVar = 5;                      -->esta variable no se puede acceder desder otras funciones   
        //favoriteNumber = favoriteNumber + 1;      -->cuantas mas operaciones hagamos mas cuesta el contrato
        //retrieve();                               -->en este caso la función de retrieve supondría un gasto 
    }

    //VIEW & PURE functions no requieren gas para ejecutarse (no hacen transacciones, solo leen)
    //es gratis siempre y cuando no se llame a esa función (retrieve) desde una funcion que si que cuesta (store)

    function retrieve() public view returns(uint256){   // view y pure se asignan a funciones que no requieren gas para ejecutarse
        return favoriteNumber; 
    }

    //crear un TIPO nuevo

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    /*
    People public person = People ({favoriteNumber:2, name: "Nicolas"});    -->declara una persona
    People public person2 = People ({favoriteNumber:3, name: "Alberto"});   -->pero se vuelve muy ineficiente declarar tantas personas
    People public person3 = People ({favoriteNumber:4, name: "Nolas"});     -->para ahorrarnos esto creamos un array y una funcion
    */

    People[] public people;     //mas eficiente hacerlo con una lista
                                //indice 0 devuelve a nicolas
                                //indice 2 devuelve a nolas

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        /*
        People memory newPerson = People ({favoriteNumber: _favoriteNumber, name:_name});   -->forma mas clara de declarar

        People memory newPerson = People(_favoriteNumber,_name);      -->esta linea es lo mismo que lo anterior pero mas simplificado
        people.push(newPerson);                                       -->importante que el orden de los atributos sea el mismo que en el struct

        -->La forma mas rápida de declarar es la que no esta comentada
        */
        people.push(People(_favoriteNumber,_name));
        nameToFavoriteNumber[_name] = _favoriteNumber;          //para guardar la relacion en el mapping
    }

    /*
        EVM (Ethereum Virtual Machine) puede almacenar informacion en 6 sitios:
            -Stack
            -Memory: la variable se almacena temporalmente
            -Storage
            -Calldata: la variable se almacena temporalmente
            -Code
            -Logs

        Arrays, Structs and Mappings no sabe donde se va a almacenar el valor entonces se necesita añadir memory al utilizarlo en funciones
        pero con uint si que sabe el compilador donde se almacena, por eso no hace falta

        EVM compatible networks Avalanche, Fantom, Polygon

    */
   
}