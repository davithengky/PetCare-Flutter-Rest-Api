-- =====================================================================
--  PetCare Vet Clinic — Skema Database MySQL 8
--  Migrasi Flutter (mock data)  ->  Laravel REST API + MySQL (Laragon)
--  Engine  : InnoDB
--  Charset : utf8mb4  |  Collation : utf8mb4_unicode_ci
--  Catatan : Jika memakai Laravel Migrations, LEWATI tabel `users`,
--            `password_reset_tokens`, `personal_access_tokens`
--            (sudah dibuat otomatis oleh Laravel/Sanctum).
-- =====================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `messages`;
DROP TABLE IF EXISTS `consultations`;
DROP TABLE IF EXISTS `reminders`;
DROP TABLE IF EXISTS `health_records`;
DROP TABLE IF EXISTS `bookings`;
DROP TABLE IF EXISTS `order_items`;
DROP TABLE IF EXISTS `orders`;
DROP TABLE IF EXISTS `cart_items`;
DROP TABLE IF EXISTS `promo_categories`;
DROP TABLE IF EXISTS `promos`;
DROP TABLE IF EXISTS `adoption_requests`;
DROP TABLE IF EXISTS `adoptions`;
DROP TABLE IF EXISTS `articles`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `clinic_service`;
DROP TABLE IF EXISTS `pets`;
DROP TABLE IF EXISTS `veterinarians`;
DROP TABLE IF EXISTS `clinics`;
DROP TABLE IF EXISTS `product_categories`;
DROP TABLE IF EXISTS `services`;
DROP TABLE IF EXISTS `personal_access_tokens`;
DROP TABLE IF EXISTS `password_reset_tokens`;
DROP TABLE IF EXISTS `users`;

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================================
--  A. CREATE TABLE
-- =====================================================================

-- ---------------------------------------------------------------------
-- A.1  USERS  (auth + profil)
-- ---------------------------------------------------------------------
CREATE TABLE `users` (
  `id`                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name`              VARCHAR(100)    NOT NULL,
  `email`             VARCHAR(150)    NOT NULL,
  `email_verified_at` TIMESTAMP       NULL DEFAULT NULL,
  `password`          VARCHAR(255)    NOT NULL,
  `phone`             VARCHAR(20)     DEFAULT NULL,
  `address`           TEXT            DEFAULT NULL,
  `membership_tier`   ENUM('basic','gold','platinum') NOT NULL DEFAULT 'basic',
  `photo_url`         VARCHAR(500)    DEFAULT NULL,
  `role`              ENUM('user','admin') NOT NULL DEFAULT 'user',
  `remember_token`    VARCHAR(100)    DEFAULT NULL,
  `created_at`        TIMESTAMP       NULL DEFAULT NULL,
  `updated_at`        TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_email` (`email`),
  KEY `idx_users_membership` (`membership_tier`),
  KEY `idx_users_role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.2  PASSWORD RESET TOKENS  (Laravel default)
-- ---------------------------------------------------------------------
CREATE TABLE `password_reset_tokens` (
  `email`      VARCHAR(150) NOT NULL,
  `token`      VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP    NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.3  PERSONAL ACCESS TOKENS  (Laravel Sanctum — token API mobile)
-- ---------------------------------------------------------------------
CREATE TABLE `personal_access_tokens` (
  `id`             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tokenable_type` VARCHAR(255)    NOT NULL,
  `tokenable_id`   BIGINT UNSIGNED NOT NULL,
  `name`           VARCHAR(255)    NOT NULL,
  `token`          VARCHAR(64)     NOT NULL,
  `abilities`      TEXT            DEFAULT NULL,
  `last_used_at`   TIMESTAMP       NULL DEFAULT NULL,
  `expires_at`     TIMESTAMP       NULL DEFAULT NULL,
  `created_at`     TIMESTAMP       NULL DEFAULT NULL,
  `updated_at`     TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_pat_token` (`token`),
  KEY `idx_pat_tokenable` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.4  PRODUCT CATEGORIES  (lookup: Makanan, Obat, Mainan, Aksesoris)
-- ---------------------------------------------------------------------
CREATE TABLE `product_categories` (
  `id`         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name`       VARCHAR(50)     NOT NULL,
  `slug`       VARCHAR(50)     NOT NULL,
  `icon`       VARCHAR(50)     DEFAULT NULL,
  `created_at` TIMESTAMP       NULL DEFAULT NULL,
  `updated_at` TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_pcat_name` (`name`),
  UNIQUE KEY `uq_pcat_slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.5  SERVICES  (lookup layanan klinik)
-- ---------------------------------------------------------------------
CREATE TABLE `services` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code`        VARCHAR(50)     NOT NULL,
  `name`        VARCHAR(100)    NOT NULL,
  `icon`        VARCHAR(50)     DEFAULT NULL,
  `description` VARCHAR(255)    DEFAULT NULL,
  `is_active`   TINYINT(1)      NOT NULL DEFAULT 1,
  `created_at`  TIMESTAMP       NULL DEFAULT NULL,
  `updated_at`  TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_services_code` (`code`),
  KEY `idx_services_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.6  CLINICS  (6 cabang PetCare)
-- ---------------------------------------------------------------------
CREATE TABLE `clinics` (
  `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name`            VARCHAR(150)    NOT NULL DEFAULT 'PetCare Vet Clinic',
  `branch_name`     VARCHAR(100)    NOT NULL,
  `address`         VARCHAR(255)    NOT NULL,
  `city`            VARCHAR(100)    NOT NULL,
  `phone`           VARCHAR(30)     DEFAULT NULL,
  `operating_hours` VARCHAR(50)     DEFAULT NULL,
  `latitude`        DECIMAL(10,7)   DEFAULT NULL,
  `longitude`       DECIMAL(10,7)   DEFAULT NULL,
  `rating`          DECIMAL(2,1)    NOT NULL DEFAULT 0.0,
  `photo_url`       VARCHAR(500)    DEFAULT NULL,
  `is_active`       TINYINT(1)      NOT NULL DEFAULT 1,
  `created_at`      TIMESTAMP       NULL DEFAULT NULL,
  `updated_at`      TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_clinics_city` (`city`),
  KEY `idx_clinics_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.8  PETS  (multi-pet per user)
-- ---------------------------------------------------------------------
CREATE TABLE `pets` (
  `id`         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`    BIGINT UNSIGNED NOT NULL,
  `name`       VARCHAR(100)    NOT NULL,
  `species`    ENUM('Kucing','Anjing','Lainnya') NOT NULL DEFAULT 'Kucing',
  `breed`      VARCHAR(100)    DEFAULT NULL,
  `gender`     ENUM('jantan','betina') NOT NULL,
  `age_months` INT UNSIGNED    NOT NULL DEFAULT 0,
  `weight_kg`  DECIMAL(5,2)    NOT NULL DEFAULT 0.00,
  `photo_url`  VARCHAR(500)    DEFAULT NULL,
  `created_at` TIMESTAMP       NULL DEFAULT NULL,
  `updated_at` TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_pets_user` (`user_id`),
  KEY `idx_pets_user_species` (`user_id`,`species`),
  CONSTRAINT `fk_pets_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.9  CLINIC_SERVICE  (pivot M:N klinik <-> layanan)
-- ---------------------------------------------------------------------
CREATE TABLE `clinic_service` (
  `id`         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `clinic_id`  BIGINT UNSIGNED NOT NULL,
  `service_id` BIGINT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP       NULL DEFAULT NULL,
  `updated_at` TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_clinic_service` (`clinic_id`,`service_id`),
  KEY `idx_cs_service` (`service_id`),
  CONSTRAINT `fk_cs_clinic` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cs_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.10 PRODUCTS  (20 produk Pet Shop)
-- ---------------------------------------------------------------------
CREATE TABLE `products` (
  `id`             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_id`    BIGINT UNSIGNED NOT NULL,
  `name`           VARCHAR(200)    NOT NULL,
  `price`          DECIMAL(12,2)   NOT NULL,
  `original_price` DECIMAL(12,2)   DEFAULT NULL,
  `stock`          INT UNSIGNED    NOT NULL DEFAULT 0,
  `description`    TEXT            DEFAULT NULL,
  `image_url`      VARCHAR(500)    DEFAULT NULL,
  `rating`         DECIMAL(2,1)    NOT NULL DEFAULT 0.0,
  `sold_count`     INT UNSIGNED    NOT NULL DEFAULT 0,
  `is_active`      TINYINT(1)      NOT NULL DEFAULT 1,
  `created_at`     TIMESTAMP       NULL DEFAULT NULL,
  `updated_at`     TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_products_category` (`category_id`),
  KEY `idx_products_active` (`is_active`),
  KEY `idx_products_price` (`price`),
  FULLTEXT KEY `ft_products_name` (`name`,`description`),
  CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `product_categories` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.11 ARTICLES  (10 artikel Pet Care Tips)
-- ---------------------------------------------------------------------
CREATE TABLE `articles` (
  `id`                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title`             VARCHAR(255)    NOT NULL,
  `category`          VARCHAR(50)     NOT NULL,
  `content`           LONGTEXT        NOT NULL,
  `cover_url`         VARCHAR(500)    DEFAULT NULL,
  `author`            VARCHAR(100)    NOT NULL,
  `read_time_minutes` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `published_at`      DATETIME        DEFAULT NULL,
  `is_published`      TINYINT(1)      NOT NULL DEFAULT 1,
  `created_at`        TIMESTAMP       NULL DEFAULT NULL,
  `updated_at`        TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_articles_category` (`category`),
  KEY `idx_articles_published` (`published_at`),
  FULLTEXT KEY `ft_articles` (`title`,`content`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.12 ADOPTIONS  (8 hewan siap adopsi)
-- ---------------------------------------------------------------------
CREATE TABLE `adoptions` (
  `id`           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`      BIGINT UNSIGNED DEFAULT NULL,      -- pemilik/uploader (NULL = klinik)
  `name`         VARCHAR(100)    NOT NULL,
  `species`      ENUM('Kucing','Anjing','Lainnya') NOT NULL DEFAULT 'Kucing',
  `age`          VARCHAR(50)     NOT NULL,          -- "5 bulan", "1 tahun" (string)
  `description`  TEXT            DEFAULT NULL,
  `contact_info` VARCHAR(100)    NOT NULL,
  `photo_url`    VARCHAR(500)    DEFAULT NULL,
  `status`       ENUM('available','pending','adopted') NOT NULL DEFAULT 'available',
  `created_at`   TIMESTAMP       NULL DEFAULT NULL,
  `updated_at`   TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_adoptions_species` (`species`),
  KEY `idx_adoptions_status` (`status`),
  CONSTRAINT `fk_adoptions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.13 ADOPTION_REQUESTS  (user mengajukan adopsi)
-- ---------------------------------------------------------------------
CREATE TABLE `adoption_requests` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `adoption_id` BIGINT UNSIGNED NOT NULL,
  `user_id`     BIGINT UNSIGNED NOT NULL,
  `message`     TEXT            DEFAULT NULL,
  `status`      ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `created_at`  TIMESTAMP       NULL DEFAULT NULL,
  `updated_at`  TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_adoption_request` (`adoption_id`,`user_id`),
  KEY `idx_ar_user` (`user_id`),
  CONSTRAINT `fk_ar_adoption` FOREIGN KEY (`adoption_id`) REFERENCES `adoptions` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ar_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.14 PROMOS  (2 promo)
-- ---------------------------------------------------------------------
CREATE TABLE `promos` (
  `id`               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title`            VARCHAR(150)    NOT NULL,
  `code`             VARCHAR(50)     DEFAULT NULL,
  `description`      VARCHAR(255)    DEFAULT NULL,
  `badge`            VARCHAR(50)     DEFAULT NULL,
  `badge_color`      VARCHAR(20)     DEFAULT NULL,
  `type`             ENUM('discount','package') NOT NULL DEFAULT 'discount',
  `discount_percent` DECIMAL(5,2)    DEFAULT NULL,
  `start_price`      DECIMAL(12,2)   DEFAULT NULL,   -- untuk promo paket ("mulai dari")
  `min_price`        DECIMAL(12,2)   DEFAULT NULL,   -- minimum transaksi
  `start_date`       DATE            DEFAULT NULL,
  `end_date`         DATE            DEFAULT NULL,
  `is_active`        TINYINT(1)      NOT NULL DEFAULT 1,
  `created_at`       TIMESTAMP       NULL DEFAULT NULL,
  `updated_at`       TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_promos_code` (`code`),
  KEY `idx_promos_active` (`is_active`),
  KEY `idx_promos_end` (`end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.15 PROMO_CATEGORIES  (pivot M:N promo <-> kategori produk)
-- ---------------------------------------------------------------------
CREATE TABLE `promo_categories` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `promo_id`    BIGINT UNSIGNED NOT NULL,
  `category_id` BIGINT UNSIGNED NOT NULL,
  `created_at`  TIMESTAMP       NULL DEFAULT NULL,
  `updated_at`  TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_promo_category` (`promo_id`,`category_id`),
  KEY `idx_pc_category` (`category_id`),
  CONSTRAINT `fk_pc_promo` FOREIGN KEY (`promo_id`) REFERENCES `promos` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pc_category` FOREIGN KEY (`category_id`) REFERENCES `product_categories` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.16 CART_ITEMS  (keranjang belanja per user)
-- ---------------------------------------------------------------------
CREATE TABLE `cart_items` (
  `id`         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`    BIGINT UNSIGNED NOT NULL,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `quantity`   INT UNSIGNED    NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP       NULL DEFAULT NULL,
  `updated_at` TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_cart_user_product` (`user_id`,`product_id`),
  KEY `idx_cart_product` (`product_id`),
  CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cart_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.17 ORDERS  (pesanan Pet Shop)
-- ---------------------------------------------------------------------
CREATE TABLE `orders` (
  `id`               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`          BIGINT UNSIGNED NOT NULL,
  `order_number`     VARCHAR(30)     NOT NULL,
  `total_amount`     DECIMAL(12,2)   NOT NULL DEFAULT 0.00,
  `shipping_address` VARCHAR(255)    NOT NULL,
  `status`           ENUM('waiting_payment','processing','shipped','delivered','cancelled')
                     NOT NULL DEFAULT 'waiting_payment',
  `payment_method`   VARCHAR(50)     DEFAULT NULL,
  `paid_at`          DATETIME        DEFAULT NULL,
  `notes`            VARCHAR(255)    DEFAULT NULL,
  `created_at`       TIMESTAMP       NULL DEFAULT NULL,
  `updated_at`       TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_orders_number` (`order_number`),
  KEY `idx_orders_user` (`user_id`),
  KEY `idx_orders_status` (`status`),
  KEY `idx_orders_created` (`created_at`),
  CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.18 ORDER_ITEMS  (snapshot harga saat beli)
-- ---------------------------------------------------------------------
CREATE TABLE `order_items` (
  `id`                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id`          BIGINT UNSIGNED NOT NULL,
  `product_id`        BIGINT UNSIGNED DEFAULT NULL,
  `product_name`      VARCHAR(200)    NOT NULL,             -- snapshot nama
  `image_url`         VARCHAR(500)    DEFAULT NULL,         -- snapshot gambar
  `price_at_purchase` DECIMAL(12,2)   NOT NULL,             -- snapshot harga
  `quantity`          INT UNSIGNED    NOT NULL DEFAULT 1,
  `subtotal`          DECIMAL(12,2)   GENERATED ALWAYS AS (`price_at_purchase` * `quantity`) STORED,
  `created_at`        TIMESTAMP       NULL DEFAULT NULL,
  `updated_at`        TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_oi_order` (`order_id`),
  KEY `idx_oi_product` (`product_id`),
  CONSTRAINT `fk_oi_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_oi_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.19 BOOKINGS  (booking layanan klinik)
-- ---------------------------------------------------------------------
CREATE TABLE `bookings` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`       BIGINT UNSIGNED NOT NULL,
  `clinic_id`     BIGINT UNSIGNED NOT NULL,
  `pet_id`        BIGINT UNSIGNED NOT NULL,
  `service_id`    BIGINT UNSIGNED NOT NULL,
  `schedule_date` DATETIME        NOT NULL,
  `notes`         VARCHAR(255)    DEFAULT NULL,
  `status`        ENUM('pending','confirmed','completed','cancelled')
                  NOT NULL DEFAULT 'confirmed',
  `created_at`    TIMESTAMP       NULL DEFAULT NULL,
  `updated_at`    TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_bookings_user` (`user_id`),
  KEY `idx_bookings_clinic` (`clinic_id`),
  KEY `idx_bookings_pet` (`pet_id`),
  KEY `idx_bookings_schedule` (`schedule_date`),
  KEY `idx_bookings_status` (`status`),
  CONSTRAINT `fk_bookings_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bookings_clinic` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bookings_pet` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bookings_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.20 HEALTH_RECORDS  (rekam medis per pet)
-- ---------------------------------------------------------------------
CREATE TABLE `health_records` (
  `id`         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `pet_id`     BIGINT UNSIGNED NOT NULL,
  `vet_id`     BIGINT UNSIGNED DEFAULT NULL,   -- tak lagi ada tabel veterinarians
  `date`       DATE            NOT NULL,
  `diagnosis`  VARCHAR(255)    NOT NULL,
  `medication` VARCHAR(255)    DEFAULT NULL,
  `notes`      TEXT            DEFAULT NULL,
  `created_at` TIMESTAMP       NULL DEFAULT NULL,
  `updated_at` TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_hr_pet` (`pet_id`),
  KEY `idx_hr_vet` (`vet_id`),
  KEY `idx_hr_date` (`date`),
  CONSTRAINT `fk_hr_pet` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.21 REMINDERS  (pengingat vaksin/obat/grooming)
-- ---------------------------------------------------------------------
CREATE TABLE `reminders` (
  `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `pet_id`          BIGINT UNSIGNED NOT NULL,
  `title`           VARCHAR(150)    NOT NULL,
  `type`            ENUM('vaccine','medicine','grooming') NOT NULL,
  `scheduled_time`  DATETIME        NOT NULL,
  `is_active`       TINYINT(1)      NOT NULL DEFAULT 1,
  `notification_id` INT             DEFAULT NULL,
  `created_at`      TIMESTAMP       NULL DEFAULT NULL,
  `updated_at`      TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_rem_pet` (`pet_id`),
  KEY `idx_rem_active` (`is_active`),
  KEY `idx_rem_scheduled` (`scheduled_time`),
  CONSTRAINT `fk_rem_pet` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.22 CONSULTATIONS  (chat bot PetBot  ATAU  chat dokter)
-- ---------------------------------------------------------------------
CREATE TABLE `consultations` (
  `id`         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`    BIGINT UNSIGNED NOT NULL,
  `vet_id`     BIGINT UNSIGNED DEFAULT NULL,   -- tak lagi ada tabel veterinarians
  `pet_id`     BIGINT UNSIGNED DEFAULT NULL,
  `type`       ENUM('bot','vet') NOT NULL DEFAULT 'bot',
  `bot_name`   VARCHAR(100)    DEFAULT NULL,
  `status`     ENUM('active','completed') NOT NULL DEFAULT 'active',
  `started_at` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ended_at`   DATETIME        DEFAULT NULL,
  `created_at` TIMESTAMP       NULL DEFAULT NULL,
  `updated_at` TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cons_user` (`user_id`),
  KEY `idx_cons_vet` (`vet_id`),
  KEY `idx_cons_status` (`status`),
  CONSTRAINT `fk_cons_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cons_pet` FOREIGN KEY (`pet_id`) REFERENCES `pets` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- A.23 MESSAGES  (pesan dalam sesi konsultasi)
-- ---------------------------------------------------------------------
CREATE TABLE `messages` (
  `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `consultation_id` BIGINT UNSIGNED NOT NULL,
  `sender_id`       BIGINT UNSIGNED DEFAULT NULL,  -- NULL = bot (Flutter memakai 0)
  `sender_type`     ENUM('user','bot','vet') NOT NULL DEFAULT 'user',
  `text`            TEXT            NOT NULL,
  `created_at`      TIMESTAMP       NULL DEFAULT NULL,
  `updated_at`      TIMESTAMP       NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_msg_cons` (`consultation_id`),
  KEY `idx_msg_created` (`created_at`),
  CONSTRAINT `fk_msg_cons` FOREIGN KEY (`consultation_id`) REFERENCES `consultations` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================================
--  B. INSERT DATA DUMMY  (sesuai mock data Flutter)
-- =====================================================================

-- B.1 USER DEFAULT — Davit Hengky (password: 123456)
INSERT INTO `users`
  (`id`,`name`,`email`,`password`,`phone`,`address`,`membership_tier`,`role`,`photo_url`,`created_at`,`updated_at`)
VALUES
  (1,'Davit Hengky','davit@petcare.com',
   '$2y$12$ILT8NoownHfAd06R46CqvuW3fyts0dyYxPHhAmUOkG2jZG0qGhhkS',
   '081234567890','Jl. Raya Darmo No. 88, Surabaya','gold','user',NULL,NOW(),NOW());

-- B.2 PRODUCT CATEGORIES
INSERT INTO `product_categories` (`id`,`name`,`slug`,`icon`,`created_at`,`updated_at`) VALUES
  (1,'Makanan','makanan','restaurant',NOW(),NOW()),
  (2,'Obat','obat','medication',NOW(),NOW()),
  (3,'Mainan','mainan','toys',NOW(),NOW()),
  (4,'Aksesoris','aksesoris','style',NOW(),NOW());

-- B.3 SERVICES
INSERT INTO `services` (`id`,`code`,`name`,`icon`,`description`,`is_active`,`created_at`,`updated_at`) VALUES
  (1,'consultation','Konsultasi','stethoscope','Pemeriksaan & konsultasi dokter hewan',1,NOW(),NOW()),
  (2,'grooming','Grooming','content_cut','Perawatan & kebersihan bulu',1,NOW(),NOW()),
  (3,'vaccination','Vaksinasi','vaccines','Vaksinasi & imunisasi',1,NOW(),NOW());

-- B.4 CLINICS (6 cabang)
INSERT INTO `clinics`
  (`id`,`name`,`branch_name`,`address`,`city`,`phone`,`operating_hours`,`latitude`,`longitude`,`rating`,`photo_url`,`is_active`,`created_at`,`updated_at`)
VALUES
  (1,'PetCare Vet Clinic','Cabang Darmo','Jl. Raya Darmo No. 88','Surabaya','031-5671234','08:00 - 21:00',NULL,NULL,4.9,'https://images.pexels.com/photos/6235020/pexels-photo-6235020.jpeg?auto=compress&cs=tinysrgb&w=600',1,NOW(),NOW()),
  (2,'PetCare Vet Clinic','Cabang Gubeng','Jl. Gubeng Airlangga No. 45','Surabaya','031-5012345','08:00 - 20:00',NULL,NULL,4.7,'https://images.pexels.com/photos/7469231/pexels-photo-7469231.jpeg?auto=compress&cs=tinysrgb&w=600',1,NOW(),NOW()),
  (3,'PetCare Vet Clinic','Cabang Merr','Jl. Dr. Ir. H. Soekarno No. 120','Surabaya','031-5923456','09:00 - 21:00',NULL,NULL,4.8,'https://images.pexels.com/photos/33394245/pexels-photo-33394245.jpeg?auto=compress&cs=tinysrgb&w=600',1,NOW(),NOW()),
  (4,'PetCare Vet Clinic','Cabang Sidoarjo','Jl. Ahmad Yani No. 55','Sidoarjo','031-8901234','08:00 - 20:00',NULL,NULL,4.6,'https://images.pexels.com/photos/38587869/pexels-photo-38587869.jpeg?auto=compress&cs=tinysrgb&w=600',1,NOW(),NOW()),
  (5,'PetCare Vet Clinic','Cabang Gresik','Jl. Veteran No. 32','Gresik','031-3987654','08:00 - 19:00',NULL,NULL,4.5,'https://images.pexels.com/photos/7800666/pexels-photo-7800666.jpeg?auto=compress&cs=tinysrgb&w=600',1,NOW(),NOW()),
  (6,'PetCare Vet Clinic','Cabang Rungkut','Jl. Rungkut Industri No. 18','Surabaya','031-8712345','08:00 - 21:00',NULL,NULL,4.9,'https://images.pexels.com/photos/7474550/pexels-photo-7474550.jpeg?auto=compress&cs=tinysrgb&w=600',1,NOW(),NOW());

-- B.5 CLINIC_SERVICE (layanan per cabang, sesuai mock)
INSERT INTO `clinic_service` (`clinic_id`,`service_id`,`created_at`,`updated_at`) VALUES
  (1,1,NOW(),NOW()),(1,2,NOW(),NOW()),(1,3,NOW(),NOW()),   -- Darmo: consultation, grooming, vaccination
  (2,1,NOW(),NOW()),(2,2,NOW(),NOW()),(2,3,NOW(),NOW()),   -- Gubeng
  (3,1,NOW(),NOW()),(3,2,NOW(),NOW()),                     -- Merr: consultation, grooming
  (4,1,NOW(),NOW()),(4,2,NOW(),NOW()),(4,3,NOW(),NOW()),   -- Sidoarjo
  (5,1,NOW(),NOW()),(5,3,NOW(),NOW()),                     -- Gresik: consultation, vaccination
  (6,1,NOW(),NOW()),(6,2,NOW(),NOW()),(6,3,NOW(),NOW());   -- Rungkut

-- B.7 PETS (mock_pets.dart kosong; 2 pet ini ditambahkan agar FK booking/
--     health-record/reminder valid. Hapus jika ingin demo onboarding.)
INSERT INTO `pets`
  (`id`,`user_id`,`name`,`species`,`breed`,`gender`,`age_months`,`weight_kg`,`photo_url`,`created_at`,`updated_at`)
VALUES
  (1,1,'Milo','Kucing','Persia','betina',8,3.80,NULL,NOW(),NOW()),
  (2,1,'Rocky','Anjing','Golden Retriever','jantan',14,12.50,NULL,NOW(),NOW());

-- B.8 PRODUCTS (20 produk dari mock_products.dart)
INSERT INTO `products`
  (`id`,`category_id`,`name`,`price`,`original_price`,`stock`,`description`,`image_url`,`rating`,`sold_count`,`is_active`,`created_at`,`updated_at`)
VALUES
  (1,1,'Royal Canin Maxi Adult 4kg',285000,325000,25,'Makanan kering bernutrisi seimbang untuk anjing dewasa ras besar (26-44 kg). Membantu menjaga kesehatan tulang, sendi, dan daya cerna optimal.','https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=600&auto=format&fit=crop',4.9,250,1,NOW(),NOW()),
  (2,1,'Whiskas Tuna 1.2kg',85000,NULL,50,'Makanan kering kucing dengan rasa tuna lezat yang diperkaya vitamin dan mineral esensial untuk bulu berkilau dan energi anabul aktif.','https://images.unsplash.com/photo-1590769383363-5681e57ff10f?w=600&q=80&fit=crop',4.7,500,1,NOW(),NOW()),
  (3,1,'Pedigree Puppy 3kg',165000,195000,30,'Formula khusus untuk anak anjing dalam masa pertumbuhan. Mengandung DHA, kalsium, dan fosfor untuk mendukung pertumbuhan gigi dan tulang kuat.','https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?w=600&auto=format&fit=crop',4.8,180,1,NOW(),NOW()),
  (4,1,'Me-O Cat Food Salmon 1kg',65000,NULL,40,'Makanan kucing dengan rasa salmon segar bernutrisi tinggi, mengandung taurin untuk kesehatan penglihatan dan vitamin C untuk kekebalan tubuh.','https://images.unsplash.com/photo-1558993457-4bc6ec2c3734?w=600&q=80&fit=crop',4.6,320,1,NOW(),NOW()),
  (5,1,'Pro Plan Kitten 1.5kg',210000,NULL,20,'Makanan super premium untuk anak kucing (1-12 bulan) dengan kolostrum untuk memperkuat sistem imun alami dan perlindungan saluran cerna.','https://images.unsplash.com/photo-1764576504536-dbdfa4cb1d9a?w=600&q=80&fit=crop',4.9,120,1,NOW(),NOW()),
  (6,1,'Alpo Adult Beef 2kg',145000,NULL,35,'Makanan anjing dewasa dengan cita rasa daging sapi lezat. Diperkaya protein hewani untuk otot kuat dan zat besi untuk darah sehat.','https://images.unsplash.com/photo-1676193866128-03a926df76ef?w=600&q=80&fit=crop',4.5,200,1,NOW(),NOW()),
  (7,2,'Frontline Plus Spot On (Kucing)',180000,NULL,30,'Obat tetes kutu ampuh untuk kucing yang membasmi kutu pinjal, caplak, dan telurnya selama 30 hari perlindungan penuh.','https://images.unsplash.com/photo-1787771206780-2c527ff20306?w=600&q=80&fit=crop',4.8,150,1,NOW(),NOW()),
  (8,2,'Obat Cacing Drontal Cat',45000,NULL,60,'Tablet obat cacing spektrum luas untuk kucing dewasa dan anak kucing. Efektif mengeliminasi cacing gelang, cacing tambang, dan cacing pita.','https://images.unsplash.com/photo-1630094539416-5e17c6191be5?w=600&q=80&fit=crop',4.7,400,1,NOW(),NOW()),
  (9,2,'Vitamin Kucing Nutri Plus',55000,NULL,45,'Gel multivitamin dan mineral berenergi tinggi untuk merangsang nafsu makan dan mempercepat pemulihan anabul pasca sakit.','https://images.unsplash.com/photo-1606235357537-84aea24d4c4f?w=600&q=80&fit=crop',4.6,280,1,NOW(),NOW()),
  (10,2,'Salep Mata Anjing Vetmedin',85000,NULL,25,'Salep antibiotik topikal untuk mengatasi radang, infeksi bakteri, dan iritasi pada mata anjing peliharaan.','https://images.unsplash.com/photo-1750125625145-7be950011e4c?w=600&q=80&fit=crop',4.5,90,1,NOW(),NOW()),
  (11,2,'Shampoo Anti Kutu Anjing',95000,115000,35,'Shampoo pembersih bulu dengan formula antiparasit alami yang mengusir kutu, meredakan gatal, dan membuat bulu wangi tahan lama.','https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?w=600&auto=format&fit=crop',4.8,220,1,NOW(),NOW()),
  (12,3,'Bola Karet Anjing Chew Toy',45000,NULL,50,'Bola gigitan dari karet non-toxic yang elastis dan tahan gigitan kuat. Membantu membersihkan plak gigi saat anabul bermain.','https://images.unsplash.com/photo-1768058430062-9e8309e7e665?w=600&auto=format&fit=crop',4.7,350,1,NOW(),NOW()),
  (13,3,'Tongkat Bulu Kucing Interaktif',35000,NULL,70,'Mainan pancingan bulu warna-warni dengan lonceng kecil yang melatih ketangkasan berburu dan membuat kucing aktif bergerak ceria.','https://images.unsplash.com/photo-1718975463952-a7ca7d2c7daf?w=600&q=80&fit=crop',4.9,600,1,NOW(),NOW()),
  (14,3,'Laser Pointer Cat Toy',55000,NULL,40,'Lampu laser LED merah aman untuk mata dengan mode multi-motif untuk mengajak kucing berlari dan melompat aktif di dalam rumah.','https://images.unsplash.com/photo-1740965683843-57af52f46456?w=600&q=80&fit=crop',4.8,420,1,NOW(),NOW()),
  (15,3,'Tikus Mainan Kucing',25000,NULL,80,'Mainan boneka tikus berbulu halus dilengkapi serbuk catnip organik yang sangat disukai dan memancing rasa penasaran kucing.','https://images.unsplash.com/photo-1768042230944-885b8c1482a2?w=600&q=80&fit=crop',4.5,500,1,NOW(),NOW()),
  (16,3,'Ring Donat Gigitan Anjing',65000,NULL,30,'Mainan gigit berbentuk donat dengan tekstur bergerigi untuk memijat gusi anak anjing dan melatih kekuatan rahang.','https://images.unsplash.com/photo-1786945999064-864a85b81765?w=600&q=80&fit=crop',4.6,180,1,NOW(),NOW()),
  (17,4,'Kalung Kucing Lonceng',35000,NULL,65,'Kalung leher bahan nilon lembut yang bisa disesuaikan ukurannya, dilengkapi lonceng gemerincing imut dan gesper pengaman pelepas cepat.','https://images.unsplash.com/photo-1546180572-28e937c8128b?w=600&q=80&fit=crop',4.7,300,1,NOW(),NOW()),
  (18,4,'Tempat Makan Stainless 2in1',85000,105000,40,'Mangkuk ganda untuk makanan dan minuman dari stainless steel anti karat dengan alas karet anti selip di bawahnya.','https://images.unsplash.com/photo-1708105612115-36a658231987?w=600&q=80&fit=crop',4.8,250,1,NOW(),NOW()),
  (19,4,'Kandang Kucing Medium',450000,NULL,15,'Kandang besi lipat kokoh ukuran 60x45x50 cm dilapisi cat anti karat dengan tatakan plastik bawah yang mudah dibersihkan.','https://images.unsplash.com/photo-1649002944575-1297b11c9a1c?w=600&q=80&fit=crop',4.6,60,1,NOW(),NOW()),
  (20,4,'Tas Gendong Anjing',195000,NULL,20,'Tas ransel pet carrier dengan ventilasi jaring bernapas dan tali pengait kerah untuk membawa anabul jalan-jalan dengan aman dan nyaman.','https://images.unsplash.com/photo-1765045952615-9e28d239f053?w=600&q=80&fit=crop',4.7,120,1,NOW(),NOW());

-- B.9 ARTICLES (10 artikel dari mock_articles.dart)
INSERT INTO `articles`
  (`id`,`title`,`category`,`content`,`cover_url`,`author`,`read_time_minutes`,`published_at`,`is_published`,`created_at`,`updated_at`)
VALUES
  (1,'5 Makanan Sehat untuk Kucing Peliharaan','Makanan','Kucing membutuhkan nutrisi seimbang yang kaya akan protein hewani untuk menjaga kesehatan tubuh dan bulunya. Makanan basah (wet food) berkualitas tinggi sangat baik untuk menjaga hidrasi ginjal anabul.\n\nSelain itu, pastikan makanan kucing mengandung asam amino esensial seperti taurin yang tidak bisa diproduksi sendiri oleh tubuh kucing. Kekurangan taurin dapat memicu gangguan penglihatan dan masalah jantung.\n\nHindari memberikan makanan manusia seperti cokelat, bawang, atau susu sapi tinggi laktosa yang dapat memicu diare serta keracunan pencernaan.','https://images.pexels.com/photos/13473569/pexels-photo-13473569.jpeg?auto=compress&cs=tinysrgb&w=600','drh. Anisa Rahma',5,DATE_SUB(NOW(), INTERVAL 3 HOUR),1,DATE_SUB(NOW(), INTERVAL 3 HOUR),DATE_SUB(NOW(), INTERVAL 3 HOUR)),
  (2,'Panduan Memberi Makan Anjing Sesuai Usia','Makanan','Kebutuhan gizi anjing berubah drastis seiring bertambahnya usia. Puppy membutuhkan porsi kalori dan kalsium lebih banyak untuk mendukung pertumbuhan tulang dan otot yang cepat.\n\nSaat memasuki usia dewasa, fokus pakan beralih ke pemeliharaan berat badan ideal dan daya tahan tubuh aktif. Berikan porsi teratur 2 kali sehari agar terhindar dari obesitas.\n\nUntuk anjing senior, pilih makanan rendah kalori namun diperkaya glukosamin dan omega-3 guna merawat kelenturan persendian serta fungsi ginjal.','https://images.pexels.com/photos/34418146/pexels-photo-34418146.jpeg?auto=compress&cs=tinysrgb&w=600','drh. Budi Prasetyo',7,DATE_SUB(NOW(), INTERVAL 1 DAY),1,DATE_SUB(NOW(), INTERVAL 1 DAY),DATE_SUB(NOW(), INTERVAL 1 DAY)),
  (3,'Cara Memandikan Kucing yang Benar','Perawatan','Sebagian besar kucing enggan terkena air, sehingga proses memandikan harus dilakukan dengan tenang dan perlahan. Gunakan air hangat suam-suam kuku agar kucing merasa relaks dan tidak kedinginan.\n\nGunakan sampo khusus kucing, hindari sampo manusia karena pH kulit kucing jauh berbeda dan bisa menimbulkan iritasi kulit parah. Mulailah menyiram dari tubuh bagian belakang secara bertahap.\n\nKeringkan bulu dengan handuk bersih lalu gunakan hair dryer berkecepatan rendah dan bersuara halus. Jangan lupa beri camilan (treats) setelah selesai sebagai apresiasi.','https://images.pexels.com/photos/6131005/pexels-photo-6131005.jpeg?auto=compress&cs=tinysrgb&w=600','Tim PetCare',4,DATE_SUB(NOW(), INTERVAL 2 DAY),1,DATE_SUB(NOW(), INTERVAL 2 DAY),DATE_SUB(NOW(), INTERVAL 2 DAY)),
  (4,'Jadwal Grooming Ideal untuk Anjing','Perawatan','Grooming rutin bukan hanya soal estetika, melainkan langkah penting menjaga kesehatan kulit, kuku, dan telinga anjing kesayangan Anda. Mandi disarankan setiap 2-4 minggu sekali tergantung jenis bulu dan aktivitas luar ruangan.\n\nMenyisir bulu harus dilakukan lebih sering, terutama untuk ras berbulu lebat seperti Golden Retriever atau Shih Tzu guna mencegah gimbal (matted fur) yang memicu sarang jamur.\n\nJangan abaikan pemotongan kuku setiap 3-4 minggu dan pembersihan daun telinga mingguan dengan cairan pembersih khusus veteriner.','https://images.pexels.com/photos/19145894/pexels-photo-19145894.jpeg?auto=compress&cs=tinysrgb&w=600','Tim PetCare',6,DATE_SUB(NOW(), INTERVAL 3 DAY),1,DATE_SUB(NOW(), INTERVAL 3 DAY),DATE_SUB(NOW(), INTERVAL 3 DAY)),
  (5,'Merawat Bulu Kucing Agar Tidak Rontok','Perawatan','Kerontokan bulu kucing bisa disebabkan oleh faktor alami pergantian bulu, alergi makanan, atau infeksi parasit kulit. Sisir bulu anabul setiap hari untuk mengangkat bulu mati dan merangsang sirkulasi darah.\n\nSuplemen minyak ikan kaya asam lemak Omega-3 dan Omega-6 terbukti efektif memperkuat akar bulu dan membuat mantel bulu tampak berkilau lebat.\n\nJika kerontokan disertai pitak kemerahan atau kucing terus menggaruk, segera bawa ke dokter hewan di klinik PetCare terdekat untuk pemeriksaan jamur atau kutu.','https://images.pexels.com/photos/29020872/pexels-photo-29020872.jpeg?auto=compress&cs=tinysrgb&w=600','drh. Citra Dewi',5,DATE_SUB(NOW(), INTERVAL 4 DAY),1,DATE_SUB(NOW(), INTERVAL 4 DAY),DATE_SUB(NOW(), INTERVAL 4 DAY)),
  (6,'Kenali Gejala Penyakit Kulit pada Anjing','Penyakit','Penyakit kulit atau dermatitis adalah keluhan paling sering pada anjing. Gejala awal meliputi sering menggaruk satu area tubuh, menjilat kaki berlebihan, dan muncul bau tidak sedap dari kulit.\n\nPenyebab umum antara lain kutu (flea allergy), infeksi jamur ringworm, atau alergi pakan berbahan dasar protein tertentu. Area yang teriritasi biasanya memerah dan bulu rontok.\n\nPenanganan medis tepat waktu dengan salep antibiotik, sampo medikasi, atau injeksi anti-gatal sangat penting agar infeksi sekunder tidak menyebar ke seluruh tubuh.','https://images.pexels.com/photos/32949053/pexels-photo-32949053.jpeg?auto=compress&cs=tinysrgb&w=600','drh. Dani Kusuma',8,DATE_SUB(NOW(), INTERVAL 5 DAY),1,DATE_SUB(NOW(), INTERVAL 5 DAY),DATE_SUB(NOW(), INTERVAL 5 DAY)),
  (7,'Bahaya Cacing pada Kucing & Cara Mengatasinya','Penyakit','Cacingan dapat menyerang kucing segala usia, terutama kitten yang tertular dari air susu induknya. Gejala yang tampak antara lain perut buncit namun badan kurus, muntah, serta bulu kusam.\n\nCacing gelang dan cacing pita dapat menyerap sari makanan secara masif dan berisiko menyebabkan anemia berat pada anak kucing.\n\nPemberian obat cacing rutin setiap 3 bulan sekali adalah perlindungan terbaik. Pastikan dosis obat disesuaikan dengan berat badan kucing Anda melalui konsultasi dokter hewan.','https://images.pexels.com/photos/8434635/pexels-photo-8434635.jpeg?auto=compress&cs=tinysrgb&w=600','drh. Anisa Rahma',6,DATE_SUB(NOW(), INTERVAL 6 DAY),1,DATE_SUB(NOW(), INTERVAL 6 DAY),DATE_SUB(NOW(), INTERVAL 6 DAY)),
  (8,'Vaksin Wajib untuk Anak Kucing','Penyakit','Vaksinasi adalah benteng pertahanan utama anak kucing dari virus mematikan seperti Panleukopenia, Calicivirus, dan Rhinotracheitis (Feline Viral Rhinotracheitis).\n\nProgram vaksin pertama dimulai pada usia 6-8 minggu dengan vaksin Tricat, dilanjutkan booster 3-4 minggu kemudian, serta vaksin rabies saat usia minimal 3 bulan.\n\nPastikan kitten dalam kondisi prima tanpa demam atau flu sebelum divaksinasi agar pembentukan antibodi berlangsung optimal.','https://images.pexels.com/photos/6900232/pexels-photo-6900232.jpeg?auto=compress&cs=tinysrgb&w=600','drh. Budi Prasetyo',5,DATE_SUB(NOW(), INTERVAL 7 DAY),1,DATE_SUB(NOW(), INTERVAL 7 DAY),DATE_SUB(NOW(), INTERVAL 7 DAY)),
  (9,'Mengapa Kucing Suka Menggaruk Sofa?','Perilaku','Menggaruk adalah naluri alami kucing untuk menandai wilayah kekuasaan dengan kelenjar aroma di telapak kakinya, sekaligus mengasah kuku dan meregangkan otot bahu.\n\nJika sofa Anda menjadi korban, solusinya bukan memarahi anabul, melainkan menyediakan media garuk (scratching post) yang kokoh dan ditempatkan tepat di dekat perabotan favoritnya.\n\nOleskan sedikit catnip di tiang garukan baru dan tutupi sisi sofa dengan pelindung sementara agar kucing terbiasa mengalihkan kebiasaannya.','https://images.pexels.com/photos/35765211/pexels-photo-35765211.jpeg?auto=compress&cs=tinysrgb&w=600','Tim PetCare',4,DATE_SUB(NOW(), INTERVAL 8 DAY),1,DATE_SUB(NOW(), INTERVAL 8 DAY),DATE_SUB(NOW(), INTERVAL 8 DAY)),
  (10,'10 Tips Membuat Anabul Betah di Rumah','Tips','Menciptakan lingkungan ramah hewan peliharaan membutuhkan perhatian pada keamanan fisik dan stimulasi mental. Sediakan area istirahat yang hangat, tenang, dan jauh dari lalu-lalang bising.\n\nBerikan mainan interaktif seperti puzzle feeder dan bola untuk mengasah insting berburu mereka. Rutin luangkan waktu 15-30 menit sehari untuk bermain dan berinteraksi secara konsisten.\n\nPastikan tempat buang air (litter box/pee pad) selalu dibersihkan setiap hari serta jauh dari mangkuk makan agar anabul merasa nyaman dan bebas stres.','https://images.pexels.com/photos/16299046/pexels-photo-16299046.jpeg?auto=compress&cs=tinysrgb&w=600','Tim PetCare',5,DATE_SUB(NOW(), INTERVAL 9 DAY),1,DATE_SUB(NOW(), INTERVAL 9 DAY),DATE_SUB(NOW(), INTERVAL 9 DAY));

-- B.10 ADOPTIONS (8 hewan dari mock_adoptions.dart)
INSERT INTO `adoptions`
  (`id`,`user_id`,`name`,`species`,`age`,`description`,`contact_info`,`photo_url`,`status`,`created_at`,`updated_at`)
VALUES
  (1,NULL,'Milo','Kucing','5 bulan','Milo adalah anak kucing domestik yang sangat ramah dan gemar mendengkur. Sudah tuntas obat cacing dan vaksin pertama, mencari orang tua asuh penyayang.','0812-3456-7890','https://images.pexels.com/photos/34719941/pexels-photo-34719941.jpeg?auto=compress&cs=tinysrgb&w=600','available',DATE_SUB(NOW(), INTERVAL 1 DAY),DATE_SUB(NOW(), INTERVAL 1 DAY)),
  (2,NULL,'Luna','Kucing','1 tahun','Luna berbulu abu-abu lembut dengan sifat yang tenang dan anggun. Sangat cocok untuk penghuni apartemen karena tidak berisik dan terbiasa litter box.','0812-9876-5432','https://images.pexels.com/photos/13473569/pexels-photo-13473569.jpeg?auto=compress&cs=tinysrgb&w=600','available',DATE_SUB(NOW(), INTERVAL 3 DAY),DATE_SUB(NOW(), INTERVAL 3 DAY)),
  (3,NULL,'Rocky','Anjing','8 bulan','Rocky merupakan anjing campuran berenergi tinggi yang suka diajak jalan sore. Pintar, patuh, dan sudah bisa perintah duduk serta salaman.','0812-2345-6789','https://images.pexels.com/photos/38306667/pexels-photo-38306667.jpeg?auto=compress&cs=tinysrgb&w=600','available',DATE_SUB(NOW(), INTERVAL 4 DAY),DATE_SUB(NOW(), INTERVAL 4 DAY)),
  (4,NULL,'Bella','Anjing','1.5 tahun','Bella anjing betina yang sangat manis dan setia. Penyayang anak kecil, sudah disteril dan sehat bebas parasit kulit.','0812-8765-4321','https://images.pexels.com/photos/32949053/pexels-photo-32949053.jpeg?auto=compress&cs=tinysrgb&w=600','available',DATE_SUB(NOW(), INTERVAL 6 DAY),DATE_SUB(NOW(), INTERVAL 6 DAY)),
  (5,NULL,'Cimol','Kucing','3 bulan','Kitten putih bersih lucu dan suka bermain bola lonceng. Sangat lincah dan sehat, siap diadopsi bersama saudaranya atau mandiri.','0812-1122-3344','https://images.pexels.com/photos/6900232/pexels-photo-6900232.jpeg?auto=compress&cs=tinysrgb&w=600','available',DATE_SUB(NOW(), INTERVAL 8 DAY),DATE_SUB(NOW(), INTERVAL 8 DAY)),
  (6,NULL,'Oyen','Kucing','2 tahun','Kucing jantan oranye bertubuh gembul yang suka tidur di pangkuan. Sangat jinak, sudah steril dan vaksin rabies lengkap.','0812-5566-7788','https://images.pexels.com/photos/29020872/pexels-photo-29020872.jpeg?auto=compress&cs=tinysrgb&w=600','available',DATE_SUB(NOW(), INTERVAL 10 DAY),DATE_SUB(NOW(), INTERVAL 10 DAY)),
  (7,NULL,'Bruno','Anjing','2 tahun','Bruno penjaga setia yang penyayang. Tubuh tegap dan lincah, sangat responsif terhadap arahan pemilik dan ramah terhadap anjing lain.','0812-9988-7766','https://images.pexels.com/photos/144608/pexels-photo-144608.jpeg?auto=compress&cs=tinysrgb&w=600','available',DATE_SUB(NOW(), INTERVAL 12 DAY),DATE_SUB(NOW(), INTERVAL 12 DAY)),
  (8,NULL,'Kiki','Kucing','7 bulan','Kiki adalah kucing tortoiseshell manis dengan mata bulat bersinar. Suka diajak bicara dan selalu menyambut pemilik di depan pintu rumah.','0812-4433-2211','https://images.pexels.com/photos/35765211/pexels-photo-35765211.jpeg?auto=compress&cs=tinysrgb&w=600','available',DATE_SUB(NOW(), INTERVAL 15 DAY),DATE_SUB(NOW(), INTERVAL 15 DAY));

-- B.11 ADOPTION_REQUESTS (opsional, 1 contoh)
INSERT INTO `adoption_requests` (`adoption_id`,`user_id`,`message`,`status`,`created_at`,`updated_at`) VALUES
  (1,1,'Saya tertarik mengadopsi Milo, sudah punya pengalaman memelihara kucing.','pending',NOW(),NOW());

-- B.12 PROMOS (2 promo)
INSERT INTO `promos`
  (`id`,`title`,`code`,`description`,`badge`,`badge_color`,`type`,`discount_percent`,`start_price`,`min_price`,`start_date`,`end_date`,`is_active`,`created_at`,`updated_at`)
VALUES
  (1,'Diskon 30% Makanan Anabul','PETHEMAT','Gunakan kode: PETHEMAT','TERBATAS','#F97316','discount',30.00,NULL,NULL,CURDATE(),DATE_ADD(CURDATE(), INTERVAL 30 DAY),1,NOW(),NOW()),
  (2,'Paket Vaksin Lengkap',NULL,'Mulai dari Rp 150.000','VAKSIN','#3B82F6','package',NULL,150000.00,NULL,CURDATE(),DATE_ADD(CURDATE(), INTERVAL 60 DAY),1,NOW(),NOW());

-- B.13 PROMO_CATEGORIES (promo 1 menargetkan kategori Makanan)
INSERT INTO `promo_categories` (`promo_id`,`category_id`,`created_at`,`updated_at`) VALUES
  (1,1,NOW(),NOW());

-- B.14 CART_ITEMS (opsional, biar keranjang ada isinya)
INSERT INTO `cart_items` (`user_id`,`product_id`,`quantity`,`created_at`,`updated_at`) VALUES
  (1,2,2,NOW(),NOW()),
  (1,15,1,NOW(),NOW());

-- B.15 ORDERS (2 pesanan dummy — id 101 & 102 seperti mock_order_repo)
INSERT INTO `orders`
  (`id`,`user_id`,`order_number`,`total_amount`,`shipping_address`,`status`,`payment_method`,`paid_at`,`notes`,`created_at`,`updated_at`)
VALUES
  (101,1,'PC-20260101-0101',205000.00,'Jl. Raya Darmo No. 88, Surabaya, 081234567890','shipped','transfer',DATE_SUB(NOW(), INTERVAL 1 DAY),NULL,DATE_SUB(NOW(), INTERVAL 2 DAY),DATE_SUB(NOW(), INTERVAL 2 DAY)),
  (102,1,'PC-20260101-0102',200000.00,'Jl. Raya Darmo No. 88, Surabaya, 081234567890','waiting_payment',NULL,NULL,NULL,DATE_SUB(NOW(), INTERVAL 5 DAY),DATE_SUB(NOW(), INTERVAL 5 DAY));

-- B.16 ORDER_ITEMS (nama/harga = snapshot saat pembelian, seperti mock)
INSERT INTO `order_items`
  (`order_id`,`product_id`,`product_name`,`image_url`,`price_at_purchase`,`quantity`,`created_at`,`updated_at`)
VALUES
  (101,2,'Whiskas Tuna 1.2kg','https://images.pexels.com/photos/28824163/pexels-photo-28824163.jpeg?auto=compress&cs=tinysrgb&w=600',85000.00,2,DATE_SUB(NOW(), INTERVAL 2 DAY),DATE_SUB(NOW(), INTERVAL 2 DAY)),
  (101,13,'Tongkat Bulu Kucing Interaktif','https://images.pexels.com/photos/26706493/pexels-photo-26706493.jpeg?auto=compress&cs=tinysrgb&w=600',35000.00,1,DATE_SUB(NOW(), INTERVAL 2 DAY),DATE_SUB(NOW(), INTERVAL 2 DAY)),
  (102,5,'Royal Canin Kitten 2kg','https://images.pexels.com/photos/34719941/pexels-photo-34719941.jpeg?auto=compress&cs=tinysrgb&w=600',110000.00,1,DATE_SUB(NOW(), INTERVAL 5 DAY),DATE_SUB(NOW(), INTERVAL 5 DAY)),
  (102,20,'Pasir Kucing Gumpal 10L','https://images.pexels.com/photos/13705506/pexels-photo-13705506.jpeg?auto=compress&cs=tinysrgb&w=600',45000.00,2,DATE_SUB(NOW(), INTERVAL 5 DAY),DATE_SUB(NOW(), INTERVAL 5 DAY));

-- B.17 BOOKINGS (2 booking dummy)
INSERT INTO `bookings`
  (`id`,`user_id`,`clinic_id`,`pet_id`,`service_id`,`schedule_date`,`notes`,`status`,`created_at`,`updated_at`)
VALUES
  (1,1,1,1,3,DATE_ADD(NOW(), INTERVAL 1 DAY),'Vaksin tahunan & cek kesehatan','confirmed',DATE_SUB(NOW(), INTERVAL 3 HOUR),DATE_SUB(NOW(), INTERVAL 3 HOUR)),
  (2,1,2,1,2,DATE_SUB(NOW(), INTERVAL 3 DAY),'Grooming bulu dan potong kuku','completed',DATE_SUB(NOW(), INTERVAL 4 DAY),DATE_SUB(NOW(), INTERVAL 4 DAY));

-- B.18 HEALTH_RECORDS (3 rekam medis dari mock_health_repo)
INSERT INTO `health_records`
  (`id`,`pet_id`,`date`,`diagnosis`,`medication`,`notes`,`created_at`,`updated_at`)
VALUES
  (1,1,DATE_SUB(CURDATE(), INTERVAL 14 DAY),'Vaksinasi Feline Tricat Rutin & Pemeriksaan Fisik','Vitamin Imunovit Gel, Obat Cacing Drontal Cat','Kondisi suhu tubuh 38.5 C normal, nafsu makan baik, berat 3.8 kg.',NOW(),NOW()),
  (2,1,DATE_SUB(CURDATE(), INTERVAL 45 DAY),'Pembersihan Telinga & Kontrol Jamur Kulit (Ear Mites)','Tetes Telinga Otopet 2x sehari selama 5 hari','Telinga kanan terdapat kotoran cokelat, kulit leher sudah membaik.',NOW(),NOW()),
  (3,2,DATE_SUB(CURDATE(), INTERVAL 20 DAY),'Vaksinasi Rabies & Cek Gigi','Spray Pembersih Karang Gigi','Gigi taring bersih, tidak ada plak berbahaya, anjing aktif.',NOW(),NOW());

-- B.19 REMINDERS (4 pengingat)
INSERT INTO `reminders`
  (`id`,`pet_id`,`title`,`type`,`scheduled_time`,`is_active`,`notification_id`,`created_at`,`updated_at`)
VALUES
  (1,1,'Booster Vaksin Tricat Tahunan','vaccine',DATE_ADD(NOW(), INTERVAL 5 DAY),1,101,NOW(),NOW()),
  (2,1,'Minum Obat Cacing Berkala','medicine',DATE_ADD(NOW(), INTERVAL 12 DAY),1,102,NOW(),NOW()),
  (3,1,'Sesi Grooming & Mandi Jamur','grooming',DATE_ADD(NOW(), INTERVAL 18 DAY),1,103,NOW(),NOW()),
  (4,2,'Vaksin Rabies Rutin','vaccine',DATE_ADD(NOW(), INTERVAL 7 DAY),1,104,NOW(),NOW());

-- B.20 CONSULTATIONS (1 sesi chat bot PetBot)
INSERT INTO `consultations`
  (`id`,`user_id`,`pet_id`,`type`,`bot_name`,`status`,`started_at`,`ended_at`,`created_at`,`updated_at`)
VALUES
  (1,1,1,'bot','PetBot PetCare','completed',
   DATE_SUB(NOW(), INTERVAL 20 MINUTE),DATE_SUB(NOW(), INTERVAL 15 MINUTE),
   DATE_SUB(NOW(), INTERVAL 20 MINUTE),DATE_SUB(NOW(), INTERVAL 15 MINUTE));

-- B.21 MESSAGES (3 pesan contoh; sender_id NULL = bot, app memetakan ke 0)
INSERT INTO `messages`
  (`consultation_id`,`sender_id`,`sender_type`,`text`,`created_at`,`updated_at`)
VALUES
  (1,NULL,'bot','Halo! 👋 Aku PetBot, asisten virtual dari PetCare Vet Clinic. Ada yang bisa aku bantu tentang anabulmu? Kamu bisa tanya soal vaksin, makanan, kesehatan, atau perawatan ya 🐾',DATE_SUB(NOW(), INTERVAL 20 MINUTE),DATE_SUB(NOW(), INTERVAL 20 MINUTE)),
  (1,1,'user','Jadwal vaksin kucing kapan ya?',DATE_SUB(NOW(), INTERVAL 18 MINUTE),DATE_SUB(NOW(), INTERVAL 18 MINUTE)),
  (1,NULL,'bot','Jadwal vaksin ideal:\n• Kucing: mulai umur 6-8 minggu, booster tiap 3-4 minggu sampai umur 16 minggu, lalu booster tahunan\n• Anjing: mulai umur 6-8 minggu, booster tiap 2-4 minggu sampai umur 16 minggu, lalu booster tahunan\n\nKonsultasikan jadwal spesifik ke dokter ya 🐾',DATE_SUB(NOW(), INTERVAL 16 MINUTE),DATE_SUB(NOW(), INTERVAL 16 MINUTE));

-- =====================================================================
--  C. INDEX & CONSTRAINT TAMBAHAN (optimasi query umum)
-- =====================================================================
-- Index komposit untuk feed aktivitas user (booking + order):
CREATE INDEX `idx_orders_user_created` ON `orders` (`user_id`,`created_at`,`status`);
CREATE INDEX `idx_bookings_user_status` ON `bookings` (`user_id`,`status`,`schedule_date`);
-- Pencarian produk pada shop:
CREATE INDEX `idx_products_cat_active` ON `products` (`category_id`,`is_active`,`price`);
-- Reminder yang akan dikirim notifikasi:
CREATE INDEX `idx_rem_pet_active_time` ON `reminders` (`pet_id`,`is_active`,`scheduled_time`);

-- =====================================================================
--  END OF SCRIPT
-- =====================================================================
