//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

//UN UNICO FICHERO DE SOLIDITY PUEDE ALMACENAR VARIOS CONTRATOS

import "./SimpleStorage.sol";   //asi es como se importa otra contrato

contract StorageFactory{        


    SimpleStorage[] public simpleStorageArray;  //creamos un array de la variable que hemos creado

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();  //al tener un array cada vez que llamamos a la función se crea un  address de contrato nuevo
        simpleStorageArray.push(simpleStorage);             //y se almacena, en vez de sobreescribrise
    }

/*
Cada vez que interactues con cualquier contrato vas a necesitar:
    -address del contrato
    -ABI ( Application Binary Interface )
*/

//FUNCION PARA ALMACENAR

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public { //almacena un numero en un contrato del array de contratos
        /*
        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
        simpleStorage.store(_simpleStorageNumber);
        */

        simpleStorageArray[_simpleStorageIndex].store(_simpleStorageNumber);    //forma mas rapida de hacerla 
                                                                                //store es la funcion que hemos creado en el otro contrato
    }

//FUNCION PARA LEER

    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256){   //devuelve el numero almacenado en un contrato de la posicion X
                                                                                //que le indiquemos en el array
        
        /*    
        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];  
        return simpleStorage.retrieve();
        */

        return simpleStorageArray[_simpleStorageIndex].retrieve();  //forma mas rapido de hacerlo
                                                                    //retrieve es la funcion que hemos creado en el otro contrato
    }
}