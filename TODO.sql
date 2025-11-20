-- =====================================================
-- TODO App - Database Setup Script
-- Database: TODO
-- =====================================================

DROP DATABASE IF EXISTS TODO;
CREATE DATABASE IF NOT EXISTS TODO;
USE TODO;

-- =====================================================
-- 1. USERS TABLE (Authentication)
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    email_verified_at TIMESTAMP NULL,
    password VARCHAR(255) NOT NULL,
    remember_token VARCHAR(100) NULL,
    two_factor_secret LONGTEXT NULL,
    two_factor_recovery_codes LONGTEXT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    INDEX idx_email (email),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 2. CATEGORIES TABLE (Task Grouping)
-- =====================================================
CREATE TABLE IF NOT EXISTS categories (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NULL,
    color VARCHAR(7) DEFAULT '#3B82F6' COMMENT 'Hex color code',
    icon VARCHAR(50) NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_is_active (is_active),
    UNIQUE KEY unique_user_category (user_id, name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 3. TASKS TABLE (Main Todo Items)
-- =====================================================
CREATE TABLE IF NOT EXISTS tasks (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    category_id BIGINT UNSIGNED NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NULL,
    status ENUM('todo', 'in_progress', 'done') DEFAULT 'todo',
    priority ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'medium',
    due_date DATE NULL,
    is_completed BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL COMMENT 'Soft delete timestamp',
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_category_id (category_id),
    INDEX idx_status (status),
    INDEX idx_priority (priority),
    INDEX idx_due_date (due_date),
    INDEX idx_is_completed (is_completed),
    INDEX idx_deleted_at (deleted_at),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 4. SUBTASKS TABLE (Task Breakdown)
-- =====================================================
CREATE TABLE IF NOT EXISTS subtasks (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    task_id BIGINT UNSIGNED NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NULL,
    is_completed BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP NULL,
    sort_order INT DEFAULT 0,
    deleted_at TIMESTAMP NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
    INDEX idx_task_id (task_id),
    INDEX idx_is_completed (is_completed),
    INDEX idx_deleted_at (deleted_at),
    INDEX idx_sort_order (sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 5. PASSWORD RESET TOKENS TABLE (Auth)
-- =====================================================
CREATE TABLE IF NOT EXISTS password_reset_tokens (
    email VARCHAR(255) PRIMARY KEY,
    token VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NULL,
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 6. SESSIONS TABLE (Auth)
-- =====================================================
CREATE TABLE IF NOT EXISTS sessions (
    id VARCHAR(255) PRIMARY KEY,
    user_id BIGINT UNSIGNED NULL,
    ip_address VARCHAR(45) NULL,
    user_agent TEXT NULL,
    payload LONGTEXT NOT NULL,
    last_activity INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_last_activity (last_activity)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 7. CACHE TABLE (Framework)
-- =====================================================
CREATE TABLE IF NOT EXISTS cache (
    key VARCHAR(255) PRIMARY KEY,
    value MEDIUMTEXT NOT NULL,
    expiration INT NOT NULL,
    INDEX idx_expiration (expiration)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 8. CACHE LOCKS TABLE (Framework)
-- =====================================================
CREATE TABLE IF NOT EXISTS cache_locks (
    key VARCHAR(255) PRIMARY KEY,
    owner VARCHAR(255) NOT NULL,
    expiration INT NOT NULL,
    INDEX idx_expiration (expiration)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 9. JOBS TABLE (Framework - Optional for async tasks)
-- =====================================================
CREATE TABLE IF NOT EXISTS jobs (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    queue VARCHAR(255) NOT NULL,
    payload LONGTEXT NOT NULL,
    attempts TINYINT UNSIGNED NOT NULL DEFAULT 0,
    reserved_at INT UNSIGNED NULL,
    available_at INT UNSIGNED NOT NULL,
    created_at INT UNSIGNED NOT NULL,
    INDEX idx_queue (queue),
    INDEX idx_reserved_at (reserved_at),
    INDEX idx_available_at (available_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 10. JOB BATCHES TABLE (Framework - Optional)
-- =====================================================
CREATE TABLE IF NOT EXISTS job_batches (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    total_jobs INT NOT NULL,
    pending_jobs INT NOT NULL,
    failed_jobs INT NOT NULL,
    failed_job_ids LONGTEXT NOT NULL,
    options MEDIUMTEXT NULL,
    cancelled_at INT NULL,
    created_at INT NOT NULL,
    finished_at INT NULL,
    INDEX idx_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 11. FAILED JOBS TABLE (Framework - Optional)
-- =====================================================
CREATE TABLE IF NOT EXISTS failed_jobs (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    uuid VARCHAR(255) NOT NULL UNIQUE,
    connection TEXT NOT NULL,
    queue TEXT NOT NULL,
    payload LONGTEXT NOT NULL,
    exception LONGTEXT NOT NULL,
    failed_at TIMESTAMP NULL,
    INDEX idx_uuid (uuid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 12. TWO FACTOR COLUMNS (Already in users table)
-- =====================================================
-- Note: two_factor_secret and two_factor_recovery_codes
-- are already added to the users table above

-- =====================================================
-- SAMPLE DATA (Optional - for testing)
-- =====================================================

-- Insert sample users
INSERT IGNORE INTO users (id, name, email, password, remember_token, created_at, updated_at) VALUES
(1, 'Test User', 'test@example.com', '$2y$12$abcdefghijklmnopqrstuvwxyz1234567890', NULL, NOW(), NOW()),
(2, 'Demo User', 'demo@example.com', '$2y$12$abcdefghijklmnopqrstuvwxyz1234567890', NULL, NOW(), NOW());

-- Insert sample categories
INSERT IGNORE INTO categories (user_id, name, description, color, icon, is_active, created_at, updated_at) VALUES
(1, 'Open', 'Alles wat je wilt - geen specifieke categorie', '#9333EA', 'inbox', TRUE, NOW(), NOW()),
(1, 'Work', 'Werk gerelateerde taken', '#EF4444', 'briefcase', TRUE, NOW(), NOW()),
(1, 'Personal', 'Persoonlijke taken', '#3B82F6', 'user', TRUE, NOW(), NOW()),
(1, 'Shopping', 'Boodschappenlijst', '#10B981', 'shopping-cart', TRUE, NOW(), NOW()),
(1, 'Health', 'Gezondheid & Fitness', '#F59E0B', 'heart', TRUE, NOW(), NOW()),
(1, 'Home', 'Huis & Onderhoud', '#8B5CF6', 'home', TRUE, NOW(), NOW()),
(2, 'Open', 'Alles wat je wilt - geen specifieke categorie', '#9333EA', 'inbox', TRUE, NOW(), NOW()),
(2, 'Work', 'Werk gerelateerde taken', '#EF4444', 'briefcase', TRUE, NOW(), NOW());

INSERT IGNORE INTO tasks (user_id, category_id, title, description, status, priority, due_date, is_completed, created_at, updated_at) VALUES
(1, 1, 'Complete project report', 'Finish and submit the quarterly report', 'in_progress', 'high', DATE_ADD(CURDATE(), INTERVAL 3 DAY), FALSE, NOW(), NOW()),
(1, 1, 'Team meeting', 'Weekly team sync', 'todo', 'medium', DATE_ADD(CURDATE(), INTERVAL 1 DAY), FALSE, NOW(), NOW()),
(1, 2, 'Buy groceries', 'Milk, bread, eggs', 'todo', 'medium', DATE_ADD(CURDATE(), INTERVAL 2 DAY), FALSE, NOW(), NOW()),
(1, 2, 'Call dentist', 'Schedule appointment', 'done', 'low', DATE_SUB(CURDATE(), INTERVAL 5 DAY), TRUE, NOW(), NOW());

-- Insert sample subtasks
INSERT IGNORE INTO subtasks (task_id, title, description, is_completed, sort_order, created_at, updated_at) VALUES
(1, 'Gather data', 'Collect all metrics', FALSE, 1, NOW(), NOW()),
(1, 'Create charts', 'Add visualization', FALSE, 2, NOW(), NOW()),
(1, 'Write summary', 'Final summary paragraph', TRUE, 3, NOW(), NOW());

-- =====================================================
-- INDEXES & CONSTRAINTS SUMMARY
-- =====================================================
-- All foreign keys are properly set with CASCADE delete
-- All active/deleted flags have indexes for quick filtering
-- User-based queries are optimized with user_id indexes
-- Timestamp indexes for date range queries
-- UNIQUE constraints to prevent duplicates
-- =====================================================
