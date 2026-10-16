-- ========================================================
-- 3학년 2학기 과학 3단원 [소리의 성질] 포트폴리오 Supabase 테이블 생성 쿼리
-- 테이블 이름: 263과학3단원소리
-- ========================================================

-- 1. 테이블 생성
create table if not exists public."263과학3단원소리" (
    id text primary key,                     -- 학생 식별자 (예: "3-1_1", "3-2_15")
    grade_class text not null,               -- 학급 (예: "3-1", "3-2", "3-3")
    student_num integer not null,            -- 번호 (1 ~ 30)
    student_name text default '',            -- 학생 이름
    lessons jsonb default '{}'::jsonb,       -- 1~14차시 누적 탐구 기록
    mind_nodes jsonb default '[]'::jsonb,    -- 소리 생각 그물 (마인드맵)
    project_image text,                      -- 작품 사진 (Base64)
    project_audio text,                      -- 마이크 녹음 소리 (Base64)
    project_link text,                       -- 작품 소개 / 대본 선택 정보
    reflection jsonb default '{}'::jsonb,    -- 단원 마무리 글쓰기
    slow_data jsonb default '{}'::jsonb,     -- 쉬운 모드(느린 학습자) 데이터
    is_submitted boolean default true,       -- 제출 및 작성 여부
    submitted_at text,                       -- 제출 일시 문자열
    updated_at timestamp with time zone default now(), -- 최근 동기화 시각
    feedback_text text default '',           -- 선생님 피드백 (학생에게 표시)
    feedback_at text default ''              -- 피드백 저장 시각
);

-- 2. 실시간 테이블 활성화 (선택 사항: Supabase Realtime)
alter publication supabase_realtime add table public."263과학3단원소리";

-- 3. RLS(Row Level Security) 활성화
alter table public."263과학3단원소리" enable row level security;

-- 4. 익명 학생 무설정(Zero-Configuration) 즉시 조회 및 저장 정책 (Policies)
-- (1) 조회 허용
create policy "누구나 조회 가능"
on public."263과학3단원소리"
for select
to anon, authenticated
using (true);

-- (2) 신규 저장 허용
create policy "누구나 신규 저장 가능"
on public."263과학3단원소리"
for insert
to anon, authenticated
with check (true);

-- (3) 수정/업데이트 허용
create policy "누구나 수정 가능"
on public."263과학3단원소리"
for update
to anon, authenticated
using (true)
with check (true);

-- 5. 기존 테이블에 피드백 컬럼 추가 (이미 생성된 경우)
alter table public."263과학3단원소리" add column if not exists feedback_text text default '';
alter table public."263과학3단원소리" add column if not exists feedback_at text default '';
