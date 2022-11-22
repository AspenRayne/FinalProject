-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema producedb
-- -----------------------------------------------------
-- This is the database for PLU price tracking	
DROP SCHEMA IF EXISTS `producedb` ;

-- -----------------------------------------------------
-- Schema producedb
--
-- This is the database for PLU price tracking	
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `producedb` DEFAULT CHARACTER SET utf8 ;
USE `producedb` ;

-- -----------------------------------------------------
-- Table `user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user` ;

CREATE TABLE IF NOT EXISTS `user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `enabled` TINYINT NULL,
  `role` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC))
ENGINE = InnoDB;

SET SQL_MODE = '';
DROP USER IF EXISTS produceuser@localhost;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'produceuser'@'localhost' IDENTIFIED BY 'produceuser';

GRANT SELECT, INSERT, TRIGGER, UPDATE, DELETE ON TABLE * TO 'produceuser'@'localhost';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `user`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`) VALUES (1, 'admin', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'ADMIN');

COMMIT;

