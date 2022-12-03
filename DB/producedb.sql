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
  `created_date` DATETIME NULL,
  `login_timestamp` DATETIME NULL,
  `about_me` TEXT NULL,
  `profile_pic` VARCHAR(2000) NULL,
  `first_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NULL,
  `email` VARCHAR(100) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ingredient`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ingredient` ;

CREATE TABLE IF NOT EXISTS `ingredient` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL,
  `description` TEXT(0) NULL,
  `upc` VARCHAR(45) NULL,
  `img_url` VARCHAR(2000) NULL,
  `plu` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `company`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `company` ;

CREATE TABLE IF NOT EXISTS `company` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `api_host_url` VARCHAR(2000) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `store`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `store` ;

CREATE TABLE IF NOT EXISTS `store` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `street1` VARCHAR(100) NULL,
  `street2` VARCHAR(45) NULL,
  `city` VARCHAR(45) NULL,
  `state` VARCHAR(2) NULL,
  `zipcode` VARCHAR(45) NULL,
  `company_id` INT NOT NULL,
  `location_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_location_store1_idx` (`company_id` ASC),
  CONSTRAINT `fk_location_store1`
    FOREIGN KEY (`company_id`)
    REFERENCES `company` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipe`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipe` ;

CREATE TABLE IF NOT EXISTS `recipe` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL,
  `description` TEXT NULL,
  `img_url` VARCHAR(2000) NULL,
  `creation_date` DATETIME NULL,
  `instructions` TEXT NULL,
  `prep_time` INT NULL,
  `cook_time` INT NULL,
  `published` TINYINT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_recipe_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_recipe_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `user_favorite_store`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user_favorite_store` ;

CREATE TABLE IF NOT EXISTS `user_favorite_store` (
  `user_id` INT NOT NULL,
  `store_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `store_id`),
  INDEX `fk_user_has_location_location1_idx` (`store_id` ASC),
  INDEX `fk_user_has_location_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_user_has_location_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_location_location1`
    FOREIGN KEY (`store_id`)
    REFERENCES `store` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `favorite_recipe`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `favorite_recipe` ;

CREATE TABLE IF NOT EXISTS `favorite_recipe` (
  `recipe_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`recipe_id`, `user_id`),
  INDEX `fk_recipe_has_user_user1_idx` (`user_id` ASC),
  INDEX `fk_recipe_has_user_recipe1_idx` (`recipe_id` ASC),
  CONSTRAINT `fk_recipe_has_user_recipe1`
    FOREIGN KEY (`recipe_id`)
    REFERENCES `recipe` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_has_user_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipe_ingredient`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipe_ingredient` ;

CREATE TABLE IF NOT EXISTS `recipe_ingredient` (
  `recipe_id` INT NOT NULL,
  `ingredient_id` INT NOT NULL,
  `measurement` VARCHAR(45) NULL,
  PRIMARY KEY (`recipe_id`, `ingredient_id`),
  INDEX `fk_recipe_has_ingredient_ingredient1_idx` (`ingredient_id` ASC),
  INDEX `fk_recipe_has_ingredient_recipe1_idx` (`recipe_id` ASC),
  CONSTRAINT `fk_recipe_has_ingredient_recipe1`
    FOREIGN KEY (`recipe_id`)
    REFERENCES `recipe` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_has_ingredient_ingredient1`
    FOREIGN KEY (`ingredient_id`)
    REFERENCES `ingredient` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `reaction`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `reaction` ;

CREATE TABLE IF NOT EXISTS `reaction` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `emoji` VARCHAR(1) CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_bin' NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipe_reaction`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipe_reaction` ;

CREATE TABLE IF NOT EXISTS `recipe_reaction` (
  `recipe_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `reaction_id` INT NOT NULL,
  `reaction_date` DATETIME NULL,
  PRIMARY KEY (`recipe_id`, `user_id`),
  INDEX `fk_recipe_has_user_user2_idx` (`user_id` ASC),
  INDEX `fk_recipe_has_user_recipe2_idx` (`recipe_id` ASC),
  INDEX `fk_recipe_reaction_reaction1_idx` (`reaction_id` ASC),
  CONSTRAINT `fk_recipe_has_user_recipe2`
    FOREIGN KEY (`recipe_id`)
    REFERENCES `recipe` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_has_user_user2`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_reaction_reaction1`
    FOREIGN KEY (`reaction_id`)
    REFERENCES `reaction` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipe_comment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recipe_comment` ;

CREATE TABLE IF NOT EXISTS `recipe_comment` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `comment_date` DATETIME NULL,
  `comment` TEXT NULL,
  `user_id` INT NOT NULL,
  `recipe_id` INT NOT NULL,
  `in_reply_to` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_recipe_comment_user1_idx` (`user_id` ASC),
  INDEX `fk_recipe_comment_recipe1_idx` (`recipe_id` ASC),
  INDEX `fk_recipe_comment_recipe_comment1_idx` (`in_reply_to` ASC),
  CONSTRAINT `fk_recipe_comment_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_comment_recipe1`
    FOREIGN KEY (`recipe_id`)
    REFERENCES `recipe` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_recipe_comment_recipe_comment1`
    FOREIGN KEY (`in_reply_to`)
    REFERENCES `recipe_comment` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `client_access`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `client_access` ;

CREATE TABLE IF NOT EXISTS `client_access` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `apikey` VARCHAR(2000) NULL,
  `expiration` TIMESTAMP NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `category` ;

CREATE TABLE IF NOT EXISTS `category` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ingredient_has_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ingredient_has_category` ;

CREATE TABLE IF NOT EXISTS `ingredient_has_category` (
  `ingredient_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  PRIMARY KEY (`ingredient_id`, `category_id`),
  INDEX `fk_ingredient_has_category_category1_idx` (`category_id` ASC),
  INDEX `fk_ingredient_has_category_ingredient1_idx` (`ingredient_id` ASC),
  CONSTRAINT `fk_ingredient_has_category_ingredient1`
    FOREIGN KEY (`ingredient_id`)
    REFERENCES `ingredient` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ingredient_has_category_category1`
    FOREIGN KEY (`category_id`)
    REFERENCES `category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
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
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (1, 'admin', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'ADMIN', '2022-11-23T00:00:00', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (2, 'jdoe', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'USER', '2022-11-23T00:00:00', NULL, 'I am the first user', 'https://pyxis.nymag.com/v1/imgs/654/1f1/08de774c11d89cb3f4ecf600a33e9c8283-24-keanu-reeves.rsquare.w700.jpg', 'John', 'Doe', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (3, 'NoobMstr', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', '2022-11-23T00:00:00', NULL, 'I am a user', '', 'Holly', 'McClain', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (4, 'FoodFan', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'stuff', '', 'Mike', 'Smith', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (5, 'WingLover', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'stuffing', '', 'Jeff', 'Johnson', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (6, 'RiceGuy', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'About us', '', 'Rob', 'Dobb', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (7, 'ShwarmaKarma', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'About things', '', 'Alice', 'Samsonite', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (8, 'ChiffonadeGirl', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Things about things', '', 'Alec', 'Redding', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (9, 'RoughChop', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Billy', 'Baldwin', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (10, 'ChefGirl', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'nope', '', 'Cullen', 'Stephan', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (11, 'YesChef', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Nolan', 'MacGregor', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (12, 'TBone22', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'More abouts', '', 'Aspen', 'Mills', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (13, 'SaladGuy33', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Mackenzie', 'Parks', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (14, 'RatatouilleRay', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, 'Fantastic about', '', 'Maximiliaan', 'Rafferty', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (15, 'HotPocket', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Logan', 'Shogun', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (16, 'FeedMe67', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Juliette', 'Peaks', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (17, 'EatThis11', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Fonz', 'Caliente', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (18, 'Chopped', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Loki', 'poki', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (19, 'RecipeKing', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Thomas', 'Train', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (20, 'HereForNuggets', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Tomas', 'Trains', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (21, 'TomahawkChop', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Lilly', 'Milly', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (22, 'BraisedForDays', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Roberto', 'Thurto', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (23, 'AuntBessie', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Jin', 'Win', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (24, 'AllGravy', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Landon', 'Smith', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (25, 'YourMom', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Rick', 'MacGregor', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (26, 'MyMom', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Michael', 'Mills', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (27, 'FindMyPeas', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Roxanne', 'Parks', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (28, 'PicklesIsMyName', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Jimmy', 'Rafferty', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (29, 'FindTheSaltine', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Jolie', 'Shogun', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (30, 'Grains1111', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Samwise', 'Peaks', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (31, 'Pasta4Brekky', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Mary', 'Caliente', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (32, 'CannedHam', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Anthony', 'poki', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (33, 'SlamminSalmon', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'William', 'Train', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (34, 'ShoNuff', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'William', 'Trains', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (35, 'SparaGuss', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Lulu', 'Milly', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (36, 'FancyFeast', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Sam', 'Thurto', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (37, 'ReallyFancyFeast', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Adamo', 'Win', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (38, 'Brainiac', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Conor', 'Smith', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (39, 'DeepFried', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Connor', 'MacGregor', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (40, '2Changs', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Mark', 'Mills', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (41, 'HotDoggyDog', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Philip', 'Parks', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (42, 'CheesePlease', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Pria', 'Rafferty', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (43, 'Hamburgler', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Chris', 'Shogun', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (44, 'FishSticks33', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Savannah', 'Peaks', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (45, 'HalfCupofLove', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Jenny', 'Caliente', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (46, 'DashOfFunk20', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Maddux', 'poki', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (47, 'PantsedOne', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Bimini', 'Train', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (48, 'Whomsit', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Remmy', 'Trains', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (49, 'ThawedLady67', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Kate', 'Milly', NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`, `email`) VALUES (50, 'DebonedAndAlone', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'User', NULL, NULL, '', '', 'Cal', 'Thurto', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `ingredient`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `ingredient` (`id`, `name`, `description`, `upc`, `img_url`, `plu`) VALUES (1, 'Flour', 'wheat based powder ', NULL, NULL, NULL);
INSERT INTO `ingredient` (`id`, `name`, `description`, `upc`, `img_url`, `plu`) VALUES (2, 'Water', 'H2O', NULL, NULL, NULL);
INSERT INTO `ingredient` (`id`, `name`, `description`, `upc`, `img_url`, `plu`) VALUES (3, 'Salt', 'table salt, iodized', NULL, NULL, NULL);
INSERT INTO `ingredient` (`id`, `name`, `description`, `upc`, `img_url`, `plu`) VALUES (4, 'ground duck', 'farm raised ground duck 1 lb', NULL, NULL, NULL);
INSERT INTO `ingredient` (`id`, `name`, `description`, `upc`, `img_url`, `plu`) VALUES (5, 'smoked paprika', 'paprika, smoked', NULL, NULL, NULL);
INSERT INTO `ingredient` (`id`, `name`, `description`, `upc`, `img_url`, `plu`) VALUES (6, 'cooking wine', 'spirits for cooking and deglazing', NULL, NULL, NULL);
INSERT INTO `ingredient` (`id`, `name`, `description`, `upc`, `img_url`, `plu`) VALUES (7, 'white onions', 'white onions', NULL, NULL, NULL);
INSERT INTO `ingredient` (`id`, `name`, `description`, `upc`, `img_url`, `plu`) VALUES (8, 'garlic', 'garlic cloves', NULL, NULL, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `company`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `company` (`id`, `name`, `api_host_url`) VALUES (1, 'King Soopers', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `store`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `store` (`id`, `street1`, `street2`, `city`, `state`, `zipcode`, `company_id`, `location_id`) VALUES (1, '17171 S. Golden Rd.', NULL, 'Golden', 'CO', '80401', 1, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `recipe`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (1, 'Duck Raviolis', 'A Recipe for Raviolis that have farm raised duck', NULL, '2022-11-23T00:00:00', 'm Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard du', 30, 60, 1, 2);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (2, 'Baked Macaroni', 'Noodles, Cheese, more cheese', 'https://hips.hearstapps.com/clv.h-cdn.co/assets/16/08/1456262739-cl-speckled-malted-coconut-cake.jpg?crop=0.950xw:0.634xh;0.0192xw,0.331xh&resize=640:*', '2022-11-28 00:00:00', 'Cook Macaroni, add cheese, bake', 25, 35, 1, 3);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (3, 'Banana Cake', 'Bananas and cake', 'https://imagesvc.meredithcorp.io/v3/mm/image?q=60&c=sc&poi=face&url=https%3A%2F%2Fimg1.cookinglight.timeinc.net%2Fsites%2Fdefault%2Ffiles%2Fstyles%2F4_3_horizontal_-_1200x900%2Fpublic%2F1542062283%2Fchocolate-and-cream-layer-cake-1812-cover.jpg%3Fitok%3DR_xDiShk', '2022-11-29 00:00:00', 'Bake in three layer pans at 350 degrees.', 20, 30, 1, 4);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (4, 'Blueberry Coffee Cake', 'Blueberry, coffee and cake', 'https://chelsweets.com/wp-content/uploads/2019/04/IMG_1029-2-735x1103.jpg', '2022-11-30 00:00:00', 'Mix butter, 1 cup sugar, flour, 2 eggs, 2 tsp vanilla, baking powder, and milk to make cake batter. Blend easily. Add 3 cups of blueberries. Put 2 1/2 cups of batter in pan. Mix cream cheese, 1/2 cup sugar, 1 egg, lemon juice and 1 tsp vanilla to make filling. Put filling on top of batter. Top with remaining batter. Make streusel topping from flour, butter, brown sugar, ad cinnamon. Sprinkle on top of cake. Bake at 375 degrees for 1 hour and 5 minutes. Check after 50 minutes.', 35, 40, 1, 2);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (5, 'Chocolate Cake', 'Chocolate and cake', 'https://www.blessthismessplease.com/wp-content/uploads/2021/04/candy-cake-5.jpg', '2022-12-1 00:00:00', 'Mix all ingredients together. Pour in 1 cup boiling water. Mix well. Bake about 35 minutes at 375 degrees.\n', 45, 45, 1, 3);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (6, 'Crazy Cake', 'Crazy and cake', 'Image url', '2022-12-2 00:00:00', 'Mix first 5 ingredients well, about 4 minutes. Bake at 350 degrees in a 9x13 pan for 35 minutes. Poke holes in warm cake and pour on mixture of powdered sugar and lemon juice.', 23, 50, 1, 5);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (7, 'Fresh Apple Cake', 'Yup, apples and cake', 'Image url', '2022-12-3 00:00:00', 'Mix apples and sugar well. Add oil, nuts, and eggs. Add vanilla and dry ingredients. Bake at 350 degrees for 40-45 minutes. Serve with whipped cream or top with cream cheese frosting.', 20, 60, 1, 6);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (8, 'Fresh Pear Cake', 'Pears and Cake', 'Image url', '2022-12-4 00:00:00', 'Butter and flour a 9 inch round pan. Peel and slice pears. Blend eggs, sugar, milk, and salt. Add flour, mix well. Fold 1/2 of pears into batter. Pour into pan, fan remaining pears on top. Dot with butter. Bake at 350 degrees about 55 minutes. Sprinkle with powdered sugar.', 15, 45, 1, 7);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (9, 'Graham Cracker Cake', 'Crackers and Cake', 'Image url', '2022-12-5 00:00:00', 'Cream butter and sugar. Add crushed crackers, sour milk, and soda. Stir in nuts. Bake in 10 inch square baking pan. Bake in 350 degree oven for 30-35 minutes. Serve with whipped cream or thin powdered sugar icing.', 25, 40, 1, 8);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (10, 'Hot Water Chocolate Cake', 'Water and Cake', 'Image url', '2022-12-6 00:00:00', 'Mix all ingredients together. Pour in 1 cup boiling water. Mix well. Bake about 35 minutes at 375 degrees.\n', 30, 35, 1, 9);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (11, 'Hungry Bear Cheese Cake', 'Bears and Cake', 'Image url', '2022-12-7 00:00:00', 'Combine first 5 ingredients to make crust. Save 1/4 cup for top. Press remaining crumbs evenly over bottom and about 2 inches up sides of a 9 inch spring form pan. Prepare filling: beat cream cheese and cottage cheese until smooth. Add eggs, one at a time, bating well. Blend in lemon juice and vanilla. Mix sugar, flour and salt. Add to cheese mixture. Pour into crust. Bake at 350 degrees until set, about 35 to 40 minutes. Combine topping ingredients (sour cream, sugar, vanilla, and salt). Spread evenly over hot cheese cake. Return to oven until cream sets, about 5 minutes. Cool in pan on rack. Sprinkle reserved crumbs around edge of cake.\n', 35, 25, 1, 12);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (12, 'Lemon Poppy Cake', 'Lemons, poppies and cake', 'Image url', '2022-12-8 00:00:00', 'Mix all for 4 minutes. Bake at 350 degrees for 40 minutes.\n', 20, 35, 1, 11);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (13, 'Light Old Fashioned Cake', 'Cake', 'Image url', '2022-12-9 00:00:00', 'Sift dry ingredients into a 4 quart bowl. Add fruit and nuts. Mix until well coated. Set aside. Cream butter, gradually add sugar and cream until fluffy. Add eggs one at a time, beating well after each. Add brandy. Combine with fruit mixture. Mix well. Turn into a 10 inch tube pan or four 1# coffee cans lined with foil, filling pans 2/3 full. Bake in slow oven, 275 degrees for 2 3/4 to 3 hours. About 1/2 hour before done brush lightly with honey or light corn syrup. Cool completely then wrap tightly in foil to store for several weeks. Brush with brandy about once a week.\n', 15, 45, 1, 12);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (14, 'My Best Gingerbread', 'Gingerbread cake', 'Image url', '2022-12-10 00:00:00', 'Bake in greased pan for 35 minutes at 325-350 degrees.\n', 20, 45, 1, 13);
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`, `user_id`) VALUES (15, 'Oatmeal Cake', 'Oatmeal and cake', 'Image url', '2022-12-11 00:00:00', 'Pour the water over the oatmeal. Let stand for 20 minutes. Add remaining cake ingredients. Mix well and pour into a greased 9\"x12\" pan. Let stand while mixing topping. To prepare topping: Mix all ingredients together over low heat, until butter melts. Spoon over unbaked cake. Bake 45 minutes at 350 degrees.\n', 30, 45, 1, 13);

COMMIT;


-- -----------------------------------------------------
-- Data for table `user_favorite_store`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `user_favorite_store` (`user_id`, `store_id`) VALUES (2, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `favorite_recipe`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `favorite_recipe` (`recipe_id`, `user_id`) VALUES (1, 2);

COMMIT;


-- -----------------------------------------------------
-- Data for table `recipe_ingredient`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `recipe_ingredient` (`recipe_id`, `ingredient_id`, `measurement`) VALUES (1, 1, '1/2 cup');
INSERT INTO `recipe_ingredient` (`recipe_id`, `ingredient_id`, `measurement`) VALUES (1, 2, '1 cup');
INSERT INTO `recipe_ingredient` (`recipe_id`, `ingredient_id`, `measurement`) VALUES (1, 3, '1 tbsp');
INSERT INTO `recipe_ingredient` (`recipe_id`, `ingredient_id`, `measurement`) VALUES (1, 4, '1 lb');
INSERT INTO `recipe_ingredient` (`recipe_id`, `ingredient_id`, `measurement`) VALUES (1, 5, '1 tbsp');
INSERT INTO `recipe_ingredient` (`recipe_id`, `ingredient_id`, `measurement`) VALUES (1, 6, '1/2 cup');
INSERT INTO `recipe_ingredient` (`recipe_id`, `ingredient_id`, `measurement`) VALUES (1, 7, '1 whole');
INSERT INTO `recipe_ingredient` (`recipe_id`, `ingredient_id`, `measurement`) VALUES (1, 8, '1 clove');

COMMIT;


-- -----------------------------------------------------
-- Data for table `reaction`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `reaction` (`id`, `emoji`) VALUES (1, '🤔');

COMMIT;


-- -----------------------------------------------------
-- Data for table `recipe_reaction`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `recipe_reaction` (`recipe_id`, `user_id`, `reaction_id`, `reaction_date`) VALUES (1, 2, 1, '2022-11-23T00:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `recipe_comment`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `recipe_comment` (`id`, `comment_date`, `comment`, `user_id`, `recipe_id`, `in_reply_to`) VALUES (1, '2022-11-23T00:00:00', 'I made this for Thanksgiving and it was off the wall!', 2, 1, NULL);

COMMIT;

