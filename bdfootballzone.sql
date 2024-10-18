-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: monorail.proxy.rlwy.net    Database: bproyecto
-- ------------------------------------------------------
-- Server version	8.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `coach`
--

DROP TABLE IF EXISTS `coach`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coach` (
  `id_coach` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) DEFAULT NULL,
  `Nacionality` varchar(45) DEFAULT NULL,
  `Photo` varchar(45) DEFAULT NULL,
  `arrival_season` varchar(45) DEFAULT NULL,
  `idteam_coach` int NOT NULL,
  PRIMARY KEY (`id_coach`),
  KEY `idTeam_idx` (`idteam_coach`),
  KEY `idTeamCoach_idx` (`idteam_coach`),
  CONSTRAINT `idTeamCoach` FOREIGN KEY (`idteam_coach`) REFERENCES `team` (`id_team`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coach`
--

LOCK TABLES `coach` WRITE;
/*!40000 ALTER TABLE `coach` DISABLE KEYS */;
INSERT INTO `coach` VALUES (1,'Carlo Ancelotti','Italiana','/imgs/coachs/ancelotti.png','21/22',1),(2,'Xavi Hernández','Española','/imgs/coachs/xavihernandez.png','21/22',2),(3,'Diego Simeone','Argentina','/imgs/coachs/simeone.png','11/22',3),(4,'Paco López','Española','/imgs/coachs/pacolopez.png','24/25',4),(6,'Quique Sanchéz Flores','Española','/imgs/coachs/quiquesanchezflores.png','2023/2024',7),(14,'Ernesto Valverde','Española','/imgs/coachs/ernestovalverde.png','2023/2024',9),(15,'Null',NULL,NULL,NULL,9),(16,'a','a','/imgs/coachs/ernestovalverde.png','2023/2024',9),(17,'Pepe Mártinez Valero','Española','/imgs/coachs/ramos.png','2023/2024',9);
/*!40000 ALTER TABLE `coach` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dietist`
--

DROP TABLE IF EXISTS `dietist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dietist` (
  `id_dietist` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `age` int DEFAULT NULL,
  `idteam_dietist` int NOT NULL,
  PRIMARY KEY (`id_dietist`),
  KEY `idDietistTeam_idx` (`idteam_dietist`),
  CONSTRAINT `idDietistTeam` FOREIGN KEY (`idteam_dietist`) REFERENCES `team` (`id_team`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dietist`
--

LOCK TABLES `dietist` WRITE;
/*!40000 ALTER TABLE `dietist` DISABLE KEYS */;
INSERT INTO `dietist` VALUES (1,'Laura Cepero Centeno ',30,4),(5,'sad',45,1);
/*!40000 ALTER TABLE `dietist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `financialaction`
--

DROP TABLE IF EXISTS `financialaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `financialaction` (
  `idFinancialaction` int NOT NULL AUTO_INCREMENT,
  `title` varchar(45) DEFAULT NULL,
  `SpentMoney` int DEFAULT NULL,
  `TicketDiscount` double DEFAULT NULL,
  `idMatchFA` int DEFAULT NULL,
  `idTeamFA` int NOT NULL,
  `EarnedMoney` int DEFAULT NULL,
  PRIMARY KEY (`idFinancialaction`),
  KEY `idMatchFA_idx` (`idMatchFA`),
  KEY `idTeamFA_idx` (`idTeamFA`),
  CONSTRAINT `idMatchFA` FOREIGN KEY (`idMatchFA`) REFERENCES `game` (`id_game`),
  CONSTRAINT `idTeamFA` FOREIGN KEY (`idTeamFA`) REFERENCES `team` (`id_team`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `financialaction`
--

LOCK TABLES `financialaction` WRITE;
/*!40000 ALTER TABLE `financialaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `financialaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game`
--

DROP TABLE IF EXISTS `game`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game` (
  `id_game` int NOT NULL AUTO_INCREMENT,
  `id_local_team` int NOT NULL,
  `id_visitant_team` int NOT NULL,
  `number_game` int NOT NULL,
  `date` datetime(6) DEFAULT NULL,
  `tickets` int NOT NULL,
  `score` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_game`),
  KEY `id_local_team_idx` (`id_local_team`),
  KEY `id_visitant_team_idx` (`id_visitant_team`),
  CONSTRAINT `id_local_team` FOREIGN KEY (`id_local_team`) REFERENCES `team` (`id_team`),
  CONSTRAINT `id_visitant_team` FOREIGN KEY (`id_visitant_team`) REFERENCES `team` (`id_team`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game`
--

LOCK TABLES `game` WRITE;
/*!40000 ALTER TABLE `game` DISABLE KEYS */;
INSERT INTO `game` VALUES (1,1,2,32,'2024-04-21 17:30:00.000000',90000,'3-2'),(2,1,3,23,'2024-02-04 21:30:00.000000',85000,'11'),(3,1,4,36,'2024-05-20 21:30:00.000000',75000,NULL),(4,2,1,17,'2024-02-12 17:30:00.000000',95000,'1-2'),(6,2,4,28,'2024-04-19 21:30:00.000000',75000,'3-2'),(8,3,2,38,'2024-05-30 21:30:00.000000',92500,NULL),(9,3,4,22,'2024-01-12 21:30:00.000000',70000,'0-1'),(10,8,1,18,'2023-12-05 16:00:00.000000',60000,'0-4'),(11,4,2,21,'2024-01-02 17:30:00.000000',50000,'1-0'),(12,4,3,28,'2024-04-18 21:30:00.000000',60000,'2-0'),(13,1,2,32,'2024-04-21 15:30:00.000000',50000,'');
/*!40000 ALTER TABLE `game` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicalpart`
--

DROP TABLE IF EXISTS `medicalpart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicalpart` (
  `id_medicalpart` int NOT NULL AUTO_INCREMENT,
  `idPhysioMP` int DEFAULT NULL,
  `idTeamMP` int NOT NULL,
  `idPlayerMP` int NOT NULL,
  `Description` longtext,
  `RecoveryMethod` longtext,
  PRIMARY KEY (`id_medicalpart`),
  KEY `idTeamMP_idx` (`idTeamMP`),
  KEY `idPlayerMP_idx` (`idPlayerMP`),
  KEY `idPhysioMP_idx` (`idPhysioMP`),
  CONSTRAINT `idPhysioMP` FOREIGN KEY (`idPhysioMP`) REFERENCES `user` (`id_user`),
  CONSTRAINT `idPlayerMP` FOREIGN KEY (`idPlayerMP`) REFERENCES `player` (`id_player`),
  CONSTRAINT `idTeamMP` FOREIGN KEY (`idTeamMP`) REFERENCES `team` (`id_team`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicalpart`
--

LOCK TABLES `medicalpart` WRITE;
/*!40000 ALTER TABLE `medicalpart` DISABLE KEYS */;
INSERT INTO `medicalpart` VALUES (3,42,4,47,'luxacion hombro derecho','1 a 2 semanas de descanso'),(6,25,4,47,'luxacion hombro derecho','1 a 2 semanas de descanso'),(7,42,4,47,'luxacion hombro derecho','1 a 2 semanas de descanso'),(8,42,4,48,'Dedo roto','1 semana de reposo'),(9,42,4,48,'hola','pa ti mi cola'),(10,42,4,47,'Ligamento cruzado anterior ','9 meses de reposo y trabajo');
/*!40000 ALTER TABLE `medicalpart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `multimedia`
--

DROP TABLE IF EXISTS `multimedia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `multimedia` (
  `id_multimedia` int NOT NULL AUTO_INCREMENT,
  `title_new` longtext,
  `description_new` longtext,
  `Image` varchar(45) DEFAULT NULL,
  `title_video` longtext,
  `Video` longtext,
  `idteammultimedia` int NOT NULL,
  PRIMARY KEY (`id_multimedia`),
  KEY `idTeamMultimedia_idx` (`idteammultimedia`),
  CONSTRAINT `idteammultimedia` FOREIGN KEY (`idteammultimedia`) REFERENCES `team` (`id_team`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `multimedia`
--

LOCK TABLES `multimedia` WRITE;
/*!40000 ALTER TABLE `multimedia` DISABLE KEYS */;
INSERT INTO `multimedia` VALUES (1,'El Cádiz  inaugura el estadio Mágico González','Afinales del mes de mayo, el Cádiz CF, con todo decidido en la Liga, viajará a El Salvador para inaugurar el estadio Jorge Mágico González en lo que se ha denominado \"Una noche Mágica\", dedicada a Jorge Alberto González Barillas, infinitamente más conocido como \'Mágico González\'. El equipo amarillo, vinculado a uno de los jugadores más carismáticos y de mayor calidad de la historia, es el invitado de honor para un partido sobre el que girarán diversos actos institucionales y que contará con la presencia de importantes figuras del mundo del fútbol.','/imgs/news/estadiomagico.jpg',NULL,NULL,4),(2,'',NULL,NULL,'Real Madrid vs Cádiz CF (3-0) | Resumen y goles','-W2Ryygd20Q',4),(5,'KROOS se RETIRA!!!','Toni Kroos anuncia su retirada del fútbol después de la Eurocopa 2024 con Alemania y no renovará con el Real Madrid','/imgs/news/kroosretiro.jpg',NULL,NULL,1),(13,NULL,NULL,NULL,'XAVI DESPEDIDO DEL BARCELONA.','MiwQ5_uBk9w',2),(16,NULL,NULL,NULL,'NUEVAS CAMISETAS OFICIALES DEL CÁDIZ CF PARA LA TEMPORADA 24/25','rcypu55EoaA',4),(19,'Hansi Flick NUEVO ENTRENADOR DEL FC BARCELONA:','El técnico alemán ha firmado por dos años con una ficha relativamente baja para lo que suele ganar un entrenador del equipo azulgrana. Ganará tres netos aunque sus ingresos pueden subir considerablemente si gana títulos ya que tiene bonus importantes.','/imgs/news/flickbarca.jpg',NULL,NULL,2);
/*!40000 ALTER TABLE `multimedia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `offer`
--

DROP TABLE IF EXISTS `offer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `offer` (
  `idOffer` int NOT NULL AUTO_INCREMENT,
  `idTeam1` int NOT NULL,
  `idTeam2` int NOT NULL,
  `TransferAmount` int DEFAULT NULL,
  `idSwapPlayer` int DEFAULT NULL,
  `OfferStatus` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idOffer`),
  KEY `idTeam1_idx` (`idTeam1`),
  KEY `idTeam2_idx` (`idTeam2`),
  KEY `idSwapPlayer_idx` (`idSwapPlayer`),
  CONSTRAINT `idSwapPlayer` FOREIGN KEY (`idSwapPlayer`) REFERENCES `player` (`id_player`),
  CONSTRAINT `idTeam1` FOREIGN KEY (`idTeam1`) REFERENCES `team` (`id_team`),
  CONSTRAINT `idTeam2` FOREIGN KEY (`idTeam2`) REFERENCES `team` (`id_team`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offer`
--

LOCK TABLES `offer` WRITE;
/*!40000 ALTER TABLE `offer` DISABLE KEYS */;
/*!40000 ALTER TABLE `offer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `physio`
--

DROP TABLE IF EXISTS `physio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `physio` (
  `id_physio` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) DEFAULT NULL,
  `Age` int DEFAULT NULL,
  `idteam_physio` int NOT NULL,
  PRIMARY KEY (`id_physio`),
  KEY `idTeamPhysio_idx` (`idteam_physio`),
  CONSTRAINT `idTeamPhysio` FOREIGN KEY (`idteam_physio`) REFERENCES `team` (`id_team`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `physio`
--

LOCK TABLES `physio` WRITE;
/*!40000 ALTER TABLE `physio` DISABLE KEYS */;
INSERT INTO `physio` VALUES (2,'Juan Manuel Dávila Hernández',45,1),(5,'Manolo Fernández López',42,4),(6,'Joan Castels Pradels',55,2);
/*!40000 ALTER TABLE `physio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player`
--

DROP TABLE IF EXISTS `player`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `player` (
  `id_player` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) DEFAULT NULL,
  `Position` varchar(45) DEFAULT NULL,
  `Age` int DEFAULT NULL,
  `Image` varchar(45) DEFAULT NULL,
  `id_team` int NOT NULL,
  `Dorsal` int DEFAULT NULL,
  `nationality` varchar(45) DEFAULT NULL,
  `market_value` int DEFAULT NULL,
  `Salary` int DEFAULT NULL,
  `Goals` int DEFAULT NULL,
  `Assists` int DEFAULT NULL,
  `yc` int DEFAULT NULL,
  `RC` int DEFAULT NULL,
  `Contract` int DEFAULT NULL,
  `FootballAspects` longtext,
  `Diet` longtext,
  `transfer_status` varchar(45) DEFAULT NULL,
  `is_sancionated` tinyint(1) DEFAULT NULL,
  `is_injured` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id_player`),
  KEY `idTeam_idx` (`id_team`),
  CONSTRAINT `idTeam` FOREIGN KEY (`id_team`) REFERENCES `team` (`id_team`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player`
--

LOCK TABLES `player` WRITE;
/*!40000 ALTER TABLE `player` DISABLE KEYS */;
INSERT INTO `player` VALUES (1,'Courtois','Portero',31,'/imgs/players/courtois.png',1,1,'Belga',31000000,3000000,8,12,0,0,2026,'Jugador muy alto y seguro por alto, entre los mejores del mundo','','Instransferible',0,0),(2,'Lunin','Portero',25,'/imgs/players/lunin.png',1,13,'Rusa',16000000,1000000,12,16,2,0,2025,'Ha dado la talla como portero suplente ','','Transferible',1,0),(3,'Mendy','Defensa',28,'/imgs/players/mendy.png',1,23,'Francesa',20000000,5000000,1,3,2,0,2028,'Cada vez que hace una ruleta para el corazón al 80% de los madriddistas','','Transferible',0,0),(4,'Militao','Defensa',26,'/imgs/players/militao.png',1,3,'Brasileña',70000000,8000000,1,0,1,0,2028,'','','',0,0),(5,'Rudiger','Defensa',31,'/imgs/players/rudiger.png',1,22,'Alemana',25000000,6000000,3,2,6,0,2026,'El loco','','Transferible',0,0),(6,'Alaba','Defensa',31,'/imgs/players/alaba.png',1,4,'Austriaca',25000000,7500000,1,3,2,0,2026,'Desafortunado con las lesiones','','',0,1),(7,'Carvajal','Defensa',32,'/imgs/players/carvajal.png',1,2,'Española',12000000,5000000,2,7,5,0,2025,'','','',0,0),(8,'Nacho','Defensa',34,'/imgs/players/nacho.png',1,6,'Española',12000000,2000000,1,0,3,0,2025,'','','Transferible',0,0),(9,'Modric','Centrocampista',25,'/imgs/players/modric.png',1,10,'',1,0,3,10,0,0,2030,'No te vayas nunca Luka ','','Instransferible',0,0),(10,'Kroos','Centrocampista',25,'/imgs/players/kroos.png',1,8,'',1,0,2,6,1,0,2030,'Te echaremos de menos Toni','','',0,0),(11,'Bellingham','Centrocampista',25,'/imgs/players/bellingham.png',1,5,'Inglesa',175000000,0,20,10,3,1,2030,'La alegría del madridismo ','','Instransferible',0,0),(12,'Valverde','Centrocampista',25,'/imgs/players/valverde.png',1,15,'',1,0,5,8,0,0,2030,'','','',0,0),(13,'ViniJr','Delantero',25,'/imgs/players/vinijr.png',1,7,'Brasileña',200000000,0,20,15,6,0,2030,'Balón de oro','','',0,0),(14,'Joselu','Delantero',25,'/imgs/players/joselu.png',1,14,'Española',1,150000,12,3,0,0,2030,'','','',0,0),(15,'Rodrygo','Delantero',25,'/imgs/players/rodrygo.png',1,11,'',1,0,12,8,0,0,2030,'','','',0,0),(16,'Ter Stegen','Portero',25,'/imgs/players/terstegen.png',2,1,'Alemana',1,0,10,10,2,0,2030,'','','Instransferible',0,0),(17,'Cancelo','Defensa',25,'/imgs/players/cancelo.png',2,2,'',1,0,6,4,0,0,2030,'','','',0,0),(18,'Araujo','Defensa',25,'/imgs/players/araujo.png',2,3,'',1,0,1,10,0,0,2030,'','','',0,0),(19,'Kounde','Defensa',25,'/imgs/players/kounde.png',2,5,'',1,0,1,10,0,0,2030,'','','',0,0),(20,'Cubarsi','Defensa',25,'/imgs/players/cubarsi.png',2,24,'',1,0,1,10,0,0,2030,'','','',0,0),(22,'Iñigo Martínez','Defensa',25,'/imgs/players/inigomartinez.png',2,4,'',1,0,1,10,0,0,2030,'','','',0,1),(23,'Pedri','Centrocampista',21,'/imgs/players/pedri.png',2,8,'',1,0,1,10,0,0,2030,'','','',0,0),(24,'Gavi','Centrocampista',20,'/imgs/players/gavi.png',2,6,'',1,0,1,10,0,0,2030,'','','',1,1),(25,'Gundogan','Centrocampista',33,'/imgs/players/gundogan.png',2,22,'',1,0,1,10,0,0,2030,'','','',0,0),(26,'De Jong','Centrocampista',25,'/imgs/players/dejong.png',2,15,'',1,0,1,10,0,0,2030,'','','',0,0),(28,'Joao Félix','Delantero',25,'/imgs/players/joaofelix.png',2,17,'',1,0,1,10,0,0,2030,'','','',0,0),(29,'Lewandowski','Delantero',35,'/imgs/players/lewandowski.png',2,9,'',1,0,1,10,0,0,2030,'','','',0,0),(30,'Lamine Yamal','Delantero',16,'/imgs/players/lamineyamal.png',2,16,'',1,0,6,10,0,0,2030,'Prodigio','','',0,0),(31,'Ferrán Torres','Delantero',25,'/imgs/players/ferran.png',2,7,'',1,0,1,10,0,0,2030,'','','',0,0),(32,'Oblak','Portero',25,'/imgs/players/oblak.png',3,1,'',1,0,10,10,0,0,2030,'','','',0,0),(33,'Reinildo','Defensa',25,'/imgs/players/reinildo.png',3,2,'',1,0,1,10,0,0,2030,'','','',0,0),(34,'Mario Hermoso','Defensa',25,'/imgs/players/hermoso.png',3,4,'',1,0,1,10,0,0,2030,'','','',0,0),(35,'Marcos Llorente','Defensa',25,'/imgs/players/llorente.png',3,6,'',1,0,1,10,0,0,2030,'','','',0,0),(37,'Giménez','Defensa',25,'/imgs/players/gimenez.png',3,3,'',1,0,1,10,0,0,2030,'','','',0,0),(38,'Savic','Defensa',25,'/imgs/players/savic.png',3,5,'',1,0,1,10,0,0,2030,'','','',0,0),(39,'Koke','Centrocampista',25,'/imgs/players/koke.png',3,8,'',1,0,1,10,0,0,2030,'','','',0,0),(40,'Lemar','Centrocampista',25,'/imgs/players/lemar.png',3,16,'',1,0,1,10,0,0,2030,'','','',0,0),(41,'De Paul','Centrocampista',25,'/imgs/players/depaul.png',3,15,'',1,0,1,10,0,0,2030,'','','',0,0),(42,'Memphis','Delantero',25,'/imgs/players/memphis.png',3,19,'',1,0,3,2,0,0,2030,'','','',0,0),(43,'Samuel Lino','Delantero',25,'/imgs/players/samulino.png',3,17,'',1,0,1,10,0,0,2030,'','','',0,0),(44,'Correa','Delantero',25,'/imgs/players/correa.png',3,10,'',1,0,1,10,0,0,2030,'','','',0,0),(45,'Griezmann','Delantero',25,'/imgs/players/griezmann.png',3,7,'',1,0,12,8,3,0,2030,'','','',0,0),(46,'Morata','Delantero',25,'/imgs/players/morata.png',3,9,'',1,0,1,10,0,0,2030,'','','',0,0),(47,'Ledesma','Portero',25,'/imgs/players/ledesma.jpg',4,1,'Argentino',12000000,0,23,10,2,0,2030,'Hola','Menos hidratos','Transferible',1,1),(48,'David Gil','Portero',25,'/imgs/players/davidgil.jpg',4,13,'Española',1,0,1,10,0,0,2030,'Hola','Hola','Transferible',1,1),(49,'Fali','Defensa',25,'/imgs/players/fali.jpg',4,3,'Española',1,0,1,10,0,0,2030,'','Menos carbohidratos','Transferible',1,0),(50,'Luis Hernández','Defensa',25,'/imgs/players/luishernandez.jpg',4,5,NULL,1,0,1,10,0,0,2030,NULL,NULL,'Transferible',0,0),(51,'Chust','Defensa',25,'/imgs/players/victorchust.jpg',4,4,NULL,1,0,1,10,0,0,2030,NULL,NULL,NULL,0,0),(52,'Pires','Defensa',25,'/imgs/players/pires.jpg',4,12,NULL,1,0,1,10,0,0,2030,NULL,NULL,NULL,0,0),(55,'Alex Fernández','Centrocampista',25,'/imgs/players/alexfernandez.jpg',4,8,NULL,1,0,1,10,0,0,2030,NULL,NULL,NULL,0,0),(56,'Rubén Alcaraz','Centrocampista',25,'/imgs/players/rubenalcaraz.jpg',4,6,NULL,1,0,1,10,0,0,2030,NULL,NULL,NULL,0,0),(58,'Escalante','Centrocampista',25,'/imgs/players/escalante.jpg',4,18,NULL,1,0,1,10,0,0,2030,NULL,NULL,NULL,0,0),(59,'Robert Navarro','Centrocampista',25,'/imgs/players/robertnavarro.jpg',4,25,NULL,1,0,1,10,0,0,2030,NULL,NULL,NULL,0,0),(61,'Chris Ramos','Delantero',25,'/imgs/players/chrisramos.jpg',4,9,NULL,1,0,1,10,0,0,2030,NULL,'Más hidratos',NULL,0,0),(62,'Darwin Machís','Delantero',25,'/imgs/players/machis.jpg',4,10,NULL,1,0,1,10,0,0,2030,NULL,NULL,NULL,0,0),(64,'Juanmi','Delantero',25,'/imgs/players/juanmi.jpg',4,19,NULL,1,0,1,10,0,0,2030,NULL,NULL,NULL,0,0),(72,'Sergio Ramos','Defensa',35,'/imgs/players/ramos.png',7,4,'Española',12000000,5000000,6,1,2,0,2024,'','','Instransferible',0,0),(74,'Jesús Navas','Defensa',38,'/imgs/players/ramos.png',7,16,'Española',10000000,2500000,3,8,1,1,2025,'','','Instransferible',1,1),(75,'Isaac Romero','Delantero',24,'/imgs/players/isaacromero.png',7,20,'Española',15000000,875000,8,4,2,0,2028,'','','Transferible',0,1),(76,'Mason Greenwood','Delantero',20,'/imgs/players/greenwood.png',9,12,'Inglesa',15000000,2250000,10,5,1,0,2025,'','','Cedido',0,1);
/*!40000 ALTER TABLE `player` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `president`
--

DROP TABLE IF EXISTS `president`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `president` (
  `id_president` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) DEFAULT NULL,
  `Nacionality` varchar(45) DEFAULT NULL,
  `Image` varchar(45) DEFAULT NULL,
  `arrival_year` int NOT NULL,
  `idteam_president` int NOT NULL,
  PRIMARY KEY (`id_president`),
  KEY `idTeamPresident_idx` (`idteam_president`),
  CONSTRAINT `idTeamPresident` FOREIGN KEY (`idteam_president`) REFERENCES `team` (`id_team`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `president`
--

LOCK TABLES `president` WRITE;
/*!40000 ALTER TABLE `president` DISABLE KEYS */;
INSERT INTO `president` VALUES (1,'Florentino Pérez','Española','/imgs/presidents/florentinoperez.png',2000,1),(2,'Joan Laporta','Española','/imgs/presidents/laporta.png',2021,2),(3,'Enrique Cerezo','Española','/imgs/presidents/cerezo.png',2003,3),(4,'Manuel Vizcaíno','Española','/imgs/presidents/vizcaino.png',2014,4),(8,'José Castro Carmona','Española','/imgs/presidents/presibetis.png',2013,7),(16,'pepe asdn sak','Españolasads','/imgs/presidents/presidente.png',2001,9),(21,'Null',NULL,NULL,2024,9);
/*!40000 ALTER TABLE `president` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `renovationoffer`
--

DROP TABLE IF EXISTS `renovationoffer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `renovationoffer` (
  `idrenovationoffer` int NOT NULL AUTO_INCREMENT,
  `idPlayerrenovation` int DEFAULT NULL,
  `year` int DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idrenovationoffer`),
  KEY `idPlayerRenovation_idx` (`idPlayerrenovation`),
  CONSTRAINT `idPlayerRenovation` FOREIGN KEY (`idPlayerrenovation`) REFERENCES `player` (`id_player`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `renovationoffer`
--

LOCK TABLES `renovationoffer` WRITE;
/*!40000 ALTER TABLE `renovationoffer` DISABLE KEYS */;
INSERT INTO `renovationoffer` VALUES (18,47,2041,NULL);
/*!40000 ALTER TABLE `renovationoffer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team`
--

DROP TABLE IF EXISTS `team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `team` (
  `id_team` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) DEFAULT NULL,
  `City` varchar(45) DEFAULT NULL,
  `Badge` varchar(45) DEFAULT NULL,
  `Stadium` varchar(45) DEFAULT NULL,
  `Capital` int DEFAULT NULL,
  `Occupation` int DEFAULT NULL,
  PRIMARY KEY (`id_team`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team`
--

LOCK TABLES `team` WRITE;
/*!40000 ALTER TABLE `team` DISABLE KEYS */;
INSERT INTO `team` VALUES (1,'RealMadrid CF','Madrid','/imgs/escudos/realmadridlogo.png','Santiago Bernabéu',300000000,81000),(2,'FC Barcelona','Barcelona','/imgs/escudos/barcalogo.png','Spotify Camp Nou',150000000,99300),(3,'Atlético de Madrid','Madrid','/imgs/escudos/atleticomadridlogo.png','Cívitas Metropolitano',100000000,70400),(4,'Cádiz CF','Cádiz','/imgs/escudos/cadizlogo.png','Nuevo Mirandilla',30000000,20700),(7,'Sevilla FC','Sevilla ','/imgs/escudos/sevilla-fc-logo.png','Ramón Sánchez Pizjuán',25000000,70000),(8,'Real Betis Balompié','Sevilla ','/imgs/escudos/realbetis.png','Benito Villamarín',40000000,50000),(9,'Agentes Libres',NULL,'',NULL,10000000,10000);
/*!40000 ALTER TABLE `team` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticketmatch`
--

DROP TABLE IF EXISTS `ticketmatch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticketmatch` (
  `idTicketmatch` int NOT NULL AUTO_INCREMENT,
  `Owner` varchar(45) DEFAULT NULL,
  `idOwnerTM` int NOT NULL,
  `idMatchTM` int NOT NULL,
  `Price` double NOT NULL,
  PRIMARY KEY (`idTicketmatch`),
  KEY `idOwnerTM_idx` (`idOwnerTM`),
  KEY `idMatchTM_idx` (`idMatchTM`),
  CONSTRAINT `idMatchTM` FOREIGN KEY (`idMatchTM`) REFERENCES `game` (`id_game`),
  CONSTRAINT `idOwnerTM` FOREIGN KEY (`idOwnerTM`) REFERENCES `user` (`id_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticketmatch`
--

LOCK TABLES `ticketmatch` WRITE;
/*!40000 ALTER TABLE `ticketmatch` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticketmatch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `training`
--

DROP TABLE IF EXISTS `training`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `training` (
  `idExerciseTraining` int NOT NULL AUTO_INCREMENT,
  `TitleExercise` varchar(45) DEFAULT NULL,
  `Image` varchar(45) DEFAULT NULL,
  `Description` varchar(45) DEFAULT NULL,
  `Video` varchar(45) DEFAULT NULL,
  `idCoachTraining` int NOT NULL,
  PRIMARY KEY (`idExerciseTraining`),
  KEY `idCoachTraining_idx` (`idCoachTraining`),
  CONSTRAINT `idCoachTraining` FOREIGN KEY (`idCoachTraining`) REFERENCES `coach` (`id_coach`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `training`
--

LOCK TABLES `training` WRITE;
/*!40000 ALTER TABLE `training` DISABLE KEYS */;
/*!40000 ALTER TABLE `training` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id_user` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) DEFAULT NULL,
  `username` varchar(45) NOT NULL,
  `password` longtext NOT NULL,
  `id_team_user` int DEFAULT NULL,
  `Role` varchar(45) NOT NULL,
  PRIMARY KEY (`id_user`),
  KEY `idTeamUser_idx` (`id_team_user`),
  CONSTRAINT `idTeamUser` FOREIGN KEY (`id_team_user`) REFERENCES `team` (`id_team`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (7,'Ivan Cruzado','ivan@gmail.com','$2a$10$UgGdlUIwCNLHqyQYB/EFOuUL.grfy7CKf3mdyjIgthF408wdcdMGy',7,'ROLE_USER'),(17,'admin','admin@gmail.com','$2a$10$CIiLprwB0wZRv3jMd2UWBOhez0W2/7HYYY65zAnU0DSjndwQuamU6',1,'ROLE_ADMIN'),(25,'Laura Cepero','laura@gmail.com','$2a$10$/P1VP5Dq5ib1ywfxTLoEa.KvItLeK9XTZib06HZ/Q7PxCZRfUEwti',4,'ROLE_USER'),(26,'Rafa','rafa@gmail.com','$2a$10$Dg3MrxMG2Sd7AnvO8rE7WuzTe56B8eWbppYkVw1IULjN7SkXbjWhC',1,'ROLE_USER'),(31,'Adrián ','adri@gmail.com','$2a$10$jZDV9LmSQDgF/30kqQ/rKu.VKDoUn49ZqeuwI4Oi6eJ4N4Y.KKGaq',1,'ROLE_USER'),(32,'José Luis','joselu@gmail.com','$2a$10$BDYGqZ2znXerS.VLr7LAw./HASNSLYCOtZM24iD0AtBOmyz1hCKkS',2,'ROLE_USER'),(37,'Cristian','cristian@gmail.com','$2a$10$ha1Bi/XaD2hepOJ7ZYN.LeAB90yhKIpNqzJmHoI178RQvaic2wtAy',1,'ROLE_USER'),(38,'Juan Manuel Dávila Hernández','juanmanuel@gmail.com','$2a$10$.skdNwlhzn4/ILKLQKHs5uzOrZbWl0TsLR3o9lgCWovUl15n.Kjfe',1,'ROLE_PHYSIO'),(39,'Maria','maria@gmail.com','$2a$10$4NBc1aN1eULz0KyQuqid2uLAN6CLAQePHkGPmCO7HIx0VYtk4QmOm',1,'ROLE_USER'),(40,'Pepe','pepe@gmail.com','$2a$10$.7/Ttlm/c80bCoki0sZ2N.1/orWTav2nz8ImkUtlQ3adqA0QPlVni',8,'ROLE_PHYSIO'),(42,'Fran','fran@gmail.com','$2a$10$kMExTkJ8z6caEgrHvDABFe9KLifChBp.gJrV0TthMmcuppsBgNJ/2',4,'ROLE_PHYSIO'),(43,'Paco','paco@gmail.com','$2a$10$U9bSx8vWagjprTfEvCcyyOG8jafP4mFL.O5ZydbL1QPtyNNggU6Pm',1,'ROLE_USER'),(44,'Alba','alba@gmail.com','$2a$10$XImU244iDGYeZ6.MYQh6HOfRulKTJIcrWWl80epSyx19FScZWlhUe',7,'ROLE_USER'),(45,'Dario','dario@gmail.com','$2a$10$KXXbc5KudBMpDY5JHOUF5.Ry5WTTv2EeM8XDxa6SlCxfTsixZVc7S',2,'ROLE_USER'),(46,'Jose Manuel','josema@gmail.com','$2a$10$J/hzv.NqQUSnrJwAHUbeo.EsbeOmLixbBvcaga4qq8T9p1HkLTjJC',4,'ROLE_USER'),(47,'Laura Cepero Centeno ','lauraceperocenteno@gmail.com','$2a$10$2wAiLRjgbWFWcmipXnukXehMqZvBFBhbNvHEogsxGbeA8iP9t/mj.',4,'ROLE_DIETIST'),(48,'Juan Manuel ','juanma@gmail.com','$2a$10$Tfo7kAJvIZ1TPu2aTW1qmOclaSJuWynEKy7SCadO6iir9L8Cr5rwW',2,'ROLE_USER'),(49,'Mario','mario@gmail.com','$2a$10$ionwHVliDJO8TrZDPhwFnu/4n0GefEV23ei/OoG5NXuPjZ9JEogjC',8,'ROLE_USER'),(50,'Paco López','pacolopez@gmail.com','$2a$10$2rABuOLMM7saQqEm2P9c/eKN3bCyePIZ3jegEE6INXx2yuOplelmK',4,'ROLE_COACH'),(51,'manolo','manolo@gmail.com','$2a$10$7fycuEUodIxfEgz37Rks/uPvYPoOTKFYH49eVUwGUhjRdEHrpzxV6',3,'ROLE_USER'),(52,'Conan Ledesma','conanledesma1@gmail.com','$2a$10$OOZ/M8XfbyiHl9CY/1dw9.31JgOSOVwbIS6.vwNAzH8DmbumApAZy',4,'ROLE_PLAYER'),(53,'Manuel Vizacino','vizcaino@gmail.com','$2a$10$NAHJ0OsI7MNACi15qf59curUCUqX6bbZ0H46Mh7DzsOfy1z3wJVqy',4,'ROLE_PRESIDENT'),(54,'Hugo','hugo@gmail.com','$2a$10$uZ7fQvQ.omP0b03NRPagL.GXUPXw70o4iLvQNJsfccGwkX1G8013K',2,'ROLE_USER');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `valorationgame`
--

DROP TABLE IF EXISTS `valorationgame`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `valorationgame` (
  `idValorationmatch` int NOT NULL AUTO_INCREMENT,
  `idMatchVM` int NOT NULL,
  `idPlayerVM` int NOT NULL,
  `DefensiveRating` int DEFAULT NULL,
  `TacticalRating` int DEFAULT NULL,
  `OffensiveRating` int DEFAULT NULL,
  `FinalScore` int DEFAULT NULL,
  PRIMARY KEY (`idValorationmatch`),
  KEY `idMatchVM_idx` (`idMatchVM`),
  KEY `idPlayerVM_idx` (`idPlayerVM`),
  CONSTRAINT `idMatchVM` FOREIGN KEY (`idMatchVM`) REFERENCES `game` (`id_game`),
  CONSTRAINT `idPlayerVM` FOREIGN KEY (`idPlayerVM`) REFERENCES `player` (`id_player`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `valorationgame`
--

LOCK TABLES `valorationgame` WRITE;
/*!40000 ALTER TABLE `valorationgame` DISABLE KEYS */;
INSERT INTO `valorationgame` VALUES (1,3,47,8,6,7,7),(3,3,48,8,6,7,7);
/*!40000 ALTER TABLE `valorationgame` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-13  0:00:49
