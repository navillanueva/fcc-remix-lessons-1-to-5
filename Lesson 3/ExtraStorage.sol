//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SimpleStorage.sol"; //importar el contrato para que se pueda heredar de el

//con "is" hacemos que el contrato ExtraStorage sea hijo de SimpleStorage


contract ExtraStorage is SimpleStorage {
    //override
    //virtual override

    function store (uint256 _favoriteNumber) public override{   //para que se pueda hacer override debemos incluir virtual en la funcion
        favoriteNumber = _favoriteNumber + 5;                   //que esta en el contrato padre
    }

}