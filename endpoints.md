URL_BASE= https://proyectointegradoapi.onrender.com/

(POST) https://proyectointegradoapi.onrender.com/api/login:

  -Parámetros: String username, String password
  
  -Respuesta Correcta: json con datos del user y el bearer token 

(POST) https://proyectointegradoapi.onrender.com/api/register:

  -Parámetros: String name, String username, String password, int id_team_user
  
  -Respuesta Correcta: json con datos del user y el bearer token 

(GET) https://proyectointegradoapi.onrender.com/apiDietist/getPlayersbyTeam (Users con ROLE_DIETIST) 

  -Parámetros: int id
  
  -Respuesta Correcta: json con una lista de jugadores 

(POST) https://proyectointegradoapi.onrender.com/apiDietist/setDiet (Users con ROLE_DIETIST) 

 -Parámetros: int idDietist, int idPlayer, String diet, 

 -Headers: 'Authorization': 'Bearer token'
  
 -Respuesta Correcta: json con una lista de jugadores 

 (GET) https://proyectointegradoapi.onrender.com/apiPhysio/getPlayersInjured (Users con ROLE_PHYSIO) 
 
 -Parámetros: int id (id del equipo del usuario) 
   
 -Headers: 'Authorization': 'Bearer token'
  
 -Respuesta Correcta: json con una lista de los jugadores lesionados del equipo


 (POST) https://proyectointegradoapi.onrender.com/apiPhysio/setMedicalPart (Users con ROLE_PHYSIO) 

 -Parámetros: int idPhysioMP, int idTeamMP, int idPlayer, String description, String recoverymethod
   
 -Headers: 'Authorization': 'Bearer token'
  
 -Respuesta Correcta: Devuelve un texto que dice Medical Part created succesfully!


(GET) https://proyectointegradoapi.onrender.com/apiPlayer/getInfoPlayer (Users con ROLE_PLAYER) 

 -Parámetros: int id (id del jugador) 
   
 -Headers: 'Authorization': 'Bearer token'
  
 -Respuesta Correcta: json con datos del jugador

 (POST) https://proyectointegradoapi.onrender.com/apiPlayer/sendRenovationoffer (Users con ROLE_PLAYER) 

 -Parámetros: int idplayerrenovation, int year
   
 -Headers: 'Authorization': 'Bearer token'
  
 -Respuesta Correcta: Devuelve un texto que dice Renovation offer sent!

 (GET) https://proyectointegradoapi.onrender.com/apiPresident/getPlayersbyTeam (Users con ROLE_PRESIDENT) 

 -Parámetros: int id (id del equipo del presidente) 
   
 -Headers: 'Authorization': 'Bearer token'
  
 -Respuesta Correcta: json con una lista de los jugadores del equipo

 (POST) https://proyectointegradoapi.onrender.com/apiPresident/setTransferible (Users con ROLE_PRESIDENT) 

 -Parámetros: int idPresident, int idPlayer
   
 -Headers: 'Authorization': 'Bearer token'
  
 -Respuesta Correcta: json con los datos del jugador modificado
