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
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ingredient`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ingredient` ;

CREATE TABLE IF NOT EXISTS `ingredient` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
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
  `api_host_url` VARCHAR(2000) NOT NULL,
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
  PRIMARY KEY (`id`))
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
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`) VALUES (1, 'admin', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'ADMIN', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `user` (`id`, `username`, `password`, `enabled`, `role`, `created_date`, `login_timestamp`, `about_me`, `profile_pic`, `first_name`, `last_name`) VALUES (2, 'jdoe', '$2a$10$4SMKDcs9jT18dbFxqtIqDeLEynC7MUrCEUbv1a/bhO.x9an9WGPvm', 1, 'USER', '2022-11-23T00:00:00', NULL, 'I am the first user', 'https://pyxis.nymag.com/v1/imgs/654/1f1/08de774c11d89cb3f4ecf600a33e9c8283-24-keanu-reeves.rsquare.w700.jpg', 'John', 'Doe');

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
-- Data for table `recipe`
-- -----------------------------------------------------
START TRANSACTION;
USE `producedb`;
INSERT INTO `recipe` (`id`, `name`, `description`, `img_url`, `creation_date`, `instructions`, `prep_time`, `cook_time`, `published`) VALUES (1, 'Duck Raviolis', 'A Recipe for Raviolis that have farm raised duck', NULL, '2022-11-23T00:00:00', 'm Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard du', 30, 60, 1);

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
INSERT INTO `reaction` (`id`, `emoji`) VALUES (1, '👍');

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

