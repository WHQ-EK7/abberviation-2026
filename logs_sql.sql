-- ① 登入紀錄表
CREATE TABLE IF NOT EXISTS login_logs (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  email TEXT,
  ip_address TEXT,
  user_agent TEXT,
  device_type TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE login_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "admin read login_logs"
  ON login_logs FOR SELECT TO authenticated
  USING ((auth.jwt() -> 'user_metadata' ->> 'role') = 'admin');
CREATE POLICY "insert login_logs"
  ON login_logs FOR INSERT TO authenticated
  WITH CHECK (true);

-- ② CMF 編輯紀錄表
CREATE TABLE IF NOT EXISTS cmf_edit_logs (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  email TEXT,
  action TEXT CHECK (action IN ('insert','update','delete')),
  cmf_id BIGINT,
  before_data JSONB,
  after_data  JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE cmf_edit_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "admin read cmf_edit_logs"
  ON cmf_edit_logs FOR SELECT TO authenticated
  USING ((auth.jwt() -> 'user_metadata' ->> 'role') = 'admin');
CREATE POLICY "insert cmf_edit_logs"
  ON cmf_edit_logs FOR INSERT TO authenticated
  WITH CHECK (true);

-- ③ 縮寫查詢紀錄表
CREATE TABLE IF NOT EXISTS abbr_search_logs (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  email TEXT,
  search_query TEXT,
  category TEXT,
  result_count INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE abbr_search_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "admin read abbr_search_logs"
  ON abbr_search_logs FOR SELECT TO authenticated
  USING ((auth.jwt() -> 'user_metadata' ->> 'role') = 'admin');
CREATE POLICY "insert abbr_search_logs"
  ON abbr_search_logs FOR INSERT TO authenticated
  WITH CHECK (true);
