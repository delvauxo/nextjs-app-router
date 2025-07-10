--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5 (Debian 17.5-1.pgdg120+1)
-- Dumped by pg_dump version 17.5 (Debian 17.5-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64),
    details_json text
);


ALTER TABLE public.admin_event_entity OWNER TO delvauxo;

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO delvauxo;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO delvauxo;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO delvauxo;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO delvauxo;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO delvauxo;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO delvauxo;

--
-- Name: client; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO delvauxo;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.client_attributes OWNER TO delvauxo;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO delvauxo;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO delvauxo;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO delvauxo;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO delvauxo;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO delvauxo;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO delvauxo;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO delvauxo;

--
-- Name: component; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO delvauxo;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.component_config OWNER TO delvauxo;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO delvauxo;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer,
    version integer DEFAULT 0
);


ALTER TABLE public.credential OWNER TO delvauxo;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO delvauxo;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO delvauxo;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO delvauxo;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255),
    details_json_long_value text
);


ALTER TABLE public.event_entity OWNER TO delvauxo;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024),
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.fed_user_attribute OWNER TO delvauxo;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO delvauxo;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO delvauxo;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO delvauxo;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO delvauxo;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO delvauxo;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO delvauxo;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO delvauxo;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO delvauxo;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO delvauxo;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO delvauxo;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL,
    organization_id character varying(255),
    hide_on_login boolean DEFAULT false
);


ALTER TABLE public.identity_provider OWNER TO delvauxo;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO delvauxo;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO delvauxo;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO delvauxo;

--
-- Name: jgroups_ping; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.jgroups_ping (
    address character varying(200) NOT NULL,
    name character varying(200),
    cluster_name character varying(200) NOT NULL,
    ip character varying(200) NOT NULL,
    coord boolean
);


ALTER TABLE public.jgroups_ping OWNER TO delvauxo;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36),
    type integer DEFAULT 0 NOT NULL,
    description character varying(255)
);


ALTER TABLE public.keycloak_group OWNER TO delvauxo;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO delvauxo;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO delvauxo;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL,
    version integer DEFAULT 0
);


ALTER TABLE public.offline_client_session OWNER TO delvauxo;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL,
    broker_session_id character varying(1024),
    version integer DEFAULT 0
);


ALTER TABLE public.offline_user_session OWNER TO delvauxo;

--
-- Name: org; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.org (
    id character varying(255) NOT NULL,
    enabled boolean NOT NULL,
    realm_id character varying(255) NOT NULL,
    group_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    alias character varying(255) NOT NULL,
    redirect_url character varying(2048)
);


ALTER TABLE public.org OWNER TO delvauxo;

--
-- Name: org_domain; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.org_domain (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    verified boolean NOT NULL,
    org_id character varying(255) NOT NULL
);


ALTER TABLE public.org_domain OWNER TO delvauxo;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO delvauxo;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO delvauxo;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO delvauxo;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


ALTER TABLE public.realm OWNER TO delvauxo;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


ALTER TABLE public.realm_attribute OWNER TO delvauxo;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO delvauxo;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO delvauxo;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO delvauxo;

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO delvauxo;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO delvauxo;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO delvauxo;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO delvauxo;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO delvauxo;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO delvauxo;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO delvauxo;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO delvauxo;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO delvauxo;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO delvauxo;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode smallint NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO delvauxo;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO delvauxo;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy smallint,
    logic smallint,
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO delvauxo;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO delvauxo;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO delvauxo;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO delvauxo;

--
-- Name: revoked_token; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.revoked_token (
    id character varying(255) NOT NULL,
    expire bigint NOT NULL
);


ALTER TABLE public.revoked_token OWNER TO delvauxo;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO delvauxo;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO delvauxo;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO delvauxo;

--
-- Name: server_config; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.server_config (
    server_config_key character varying(255) NOT NULL,
    value text NOT NULL,
    version integer DEFAULT 0
);


ALTER TABLE public.server_config OWNER TO delvauxo;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.user_attribute OWNER TO delvauxo;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO delvauxo;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO delvauxo;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_entity OWNER TO delvauxo;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO delvauxo;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO delvauxo;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO delvauxo;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO delvauxo;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL,
    membership_type character varying(255) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO delvauxo;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO delvauxo;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO delvauxo;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: delvauxo
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO delvauxo;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type, details_json) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
581efe7a-e11c-4505-9530-aa8c3797f3e0	\N	auth-cookie	b438138c-504f-4895-bc39-d44717b59327	b6ba99d2-5883-4a3c-b784-c3e943194864	2	10	f	\N	\N
a2511e23-4794-4664-8d06-463d743ef4c1	\N	auth-spnego	b438138c-504f-4895-bc39-d44717b59327	b6ba99d2-5883-4a3c-b784-c3e943194864	3	20	f	\N	\N
aca2816b-dccb-439c-834f-1d1f9d47c221	\N	identity-provider-redirector	b438138c-504f-4895-bc39-d44717b59327	b6ba99d2-5883-4a3c-b784-c3e943194864	2	25	f	\N	\N
509e9fcd-2617-44a7-b675-1400ded379c7	\N	\N	b438138c-504f-4895-bc39-d44717b59327	b6ba99d2-5883-4a3c-b784-c3e943194864	2	30	t	368a687b-972c-461e-972c-e1446c8ff07f	\N
ea4ebfcb-d9c1-4889-b139-228fd1b17164	\N	auth-username-password-form	b438138c-504f-4895-bc39-d44717b59327	368a687b-972c-461e-972c-e1446c8ff07f	0	10	f	\N	\N
5240acca-f6e4-48a6-81bd-ee5f40415b81	\N	\N	b438138c-504f-4895-bc39-d44717b59327	368a687b-972c-461e-972c-e1446c8ff07f	1	20	t	65d8a787-3921-45bb-8f6c-1ce4787c3f3b	\N
982b9179-47df-4616-a5bf-ad20a81ebc10	\N	conditional-user-configured	b438138c-504f-4895-bc39-d44717b59327	65d8a787-3921-45bb-8f6c-1ce4787c3f3b	0	10	f	\N	\N
da711ca3-330d-466f-937e-a61e637f84d9	\N	auth-otp-form	b438138c-504f-4895-bc39-d44717b59327	65d8a787-3921-45bb-8f6c-1ce4787c3f3b	2	20	f	\N	\N
dc148c0b-8126-46a8-a945-defa50372524	\N	webauthn-authenticator	b438138c-504f-4895-bc39-d44717b59327	65d8a787-3921-45bb-8f6c-1ce4787c3f3b	3	30	f	\N	\N
c5d26e01-ce1e-4377-ab49-3ee130473e58	\N	auth-recovery-authn-code-form	b438138c-504f-4895-bc39-d44717b59327	65d8a787-3921-45bb-8f6c-1ce4787c3f3b	3	40	f	\N	\N
f228c2eb-c071-43be-b14e-bad0f3fd61e8	\N	direct-grant-validate-username	b438138c-504f-4895-bc39-d44717b59327	577dba76-0d2c-4fe2-af5d-15a8c0261f39	0	10	f	\N	\N
1c56e0f9-3b82-451a-8ba2-d507b602cb1c	\N	direct-grant-validate-password	b438138c-504f-4895-bc39-d44717b59327	577dba76-0d2c-4fe2-af5d-15a8c0261f39	0	20	f	\N	\N
f0cc627d-266d-4a19-a67f-afd9ec0f4524	\N	\N	b438138c-504f-4895-bc39-d44717b59327	577dba76-0d2c-4fe2-af5d-15a8c0261f39	1	30	t	c167f457-b9bc-437d-a09e-5909ee98749c	\N
ce4f9f24-737f-4154-b518-82ce006e9789	\N	conditional-user-configured	b438138c-504f-4895-bc39-d44717b59327	c167f457-b9bc-437d-a09e-5909ee98749c	0	10	f	\N	\N
554c27a4-d50b-484c-8c43-dd069d0ec506	\N	direct-grant-validate-otp	b438138c-504f-4895-bc39-d44717b59327	c167f457-b9bc-437d-a09e-5909ee98749c	0	20	f	\N	\N
d7037d40-871a-487a-988e-69886430ab33	\N	registration-page-form	b438138c-504f-4895-bc39-d44717b59327	2b2b334a-1572-4f24-aee4-033e5f2a9e22	0	10	t	b4054718-7264-43e1-832f-be07a7b29a84	\N
a40581e6-2385-4288-8ca7-952f8ada7d2b	\N	registration-user-creation	b438138c-504f-4895-bc39-d44717b59327	b4054718-7264-43e1-832f-be07a7b29a84	0	20	f	\N	\N
8c195492-83c3-415c-af8e-797d5c9d41fb	\N	registration-password-action	b438138c-504f-4895-bc39-d44717b59327	b4054718-7264-43e1-832f-be07a7b29a84	0	50	f	\N	\N
02957fa7-9231-4719-8eb7-a25a0fe9c7f8	\N	registration-recaptcha-action	b438138c-504f-4895-bc39-d44717b59327	b4054718-7264-43e1-832f-be07a7b29a84	3	60	f	\N	\N
bbeb0d53-a843-49e7-8a82-278bbf29bc5f	\N	registration-terms-and-conditions	b438138c-504f-4895-bc39-d44717b59327	b4054718-7264-43e1-832f-be07a7b29a84	3	70	f	\N	\N
21ef62d1-90d6-4f4e-b5d5-d1a6bc74e386	\N	reset-credentials-choose-user	b438138c-504f-4895-bc39-d44717b59327	27ee01e9-fcf9-4177-bec2-404aef9d5879	0	10	f	\N	\N
3e615593-c0df-4883-9f5a-d7fcba59fc65	\N	reset-credential-email	b438138c-504f-4895-bc39-d44717b59327	27ee01e9-fcf9-4177-bec2-404aef9d5879	0	20	f	\N	\N
d7641626-3329-4278-b6a3-232aa843c9c8	\N	reset-password	b438138c-504f-4895-bc39-d44717b59327	27ee01e9-fcf9-4177-bec2-404aef9d5879	0	30	f	\N	\N
f19752a7-fe1e-455b-b9c1-85955c476350	\N	\N	b438138c-504f-4895-bc39-d44717b59327	27ee01e9-fcf9-4177-bec2-404aef9d5879	1	40	t	94a49b9e-9807-4874-a18c-25c06bd31624	\N
21daddab-465d-40f2-9282-ef3f8fb5e169	\N	conditional-user-configured	b438138c-504f-4895-bc39-d44717b59327	94a49b9e-9807-4874-a18c-25c06bd31624	0	10	f	\N	\N
2b0f79b8-4c8c-41e2-8119-76abe40b391e	\N	reset-otp	b438138c-504f-4895-bc39-d44717b59327	94a49b9e-9807-4874-a18c-25c06bd31624	0	20	f	\N	\N
64b94eb4-2fca-4918-ab3b-c99e18ae1b3c	\N	client-secret	b438138c-504f-4895-bc39-d44717b59327	406ec97c-1681-463e-9496-8e966798cb5f	2	10	f	\N	\N
fc29b1ae-acf5-4e83-b05a-acc60e0221c5	\N	client-jwt	b438138c-504f-4895-bc39-d44717b59327	406ec97c-1681-463e-9496-8e966798cb5f	2	20	f	\N	\N
b7b055e7-853b-4644-ae13-3c76323fefaa	\N	client-secret-jwt	b438138c-504f-4895-bc39-d44717b59327	406ec97c-1681-463e-9496-8e966798cb5f	2	30	f	\N	\N
b01a3291-c4e5-4d2f-ae2e-9cebb99e76d0	\N	client-x509	b438138c-504f-4895-bc39-d44717b59327	406ec97c-1681-463e-9496-8e966798cb5f	2	40	f	\N	\N
9c1dc7ef-159a-4095-82bd-4eb12ada1c19	\N	idp-review-profile	b438138c-504f-4895-bc39-d44717b59327	3236e8e9-efe1-4d6c-8424-f3a54e2d1a75	0	10	f	\N	740ad9c5-3fac-4077-9e9b-21bd8e3d98c1
1c11aece-8797-4f3c-b43f-05e0a202e11c	\N	\N	b438138c-504f-4895-bc39-d44717b59327	3236e8e9-efe1-4d6c-8424-f3a54e2d1a75	0	20	t	25ad4e70-88a2-4714-a5bb-5133fc3d576c	\N
9df0aee1-c718-4281-a89e-f23a4d4d0e4d	\N	idp-create-user-if-unique	b438138c-504f-4895-bc39-d44717b59327	25ad4e70-88a2-4714-a5bb-5133fc3d576c	2	10	f	\N	27b13851-2a66-4ba1-90ef-b50ad807171b
775bb0f8-3519-4adb-8829-4eda48d553c6	\N	\N	b438138c-504f-4895-bc39-d44717b59327	25ad4e70-88a2-4714-a5bb-5133fc3d576c	2	20	t	5254a454-7998-4f92-bf34-c4b0a262de66	\N
15a0bd46-610c-4e6f-b257-7e5b01f31d2f	\N	idp-confirm-link	b438138c-504f-4895-bc39-d44717b59327	5254a454-7998-4f92-bf34-c4b0a262de66	0	10	f	\N	\N
81293945-e7c8-4138-bc6e-cc4cc6b0fc13	\N	\N	b438138c-504f-4895-bc39-d44717b59327	5254a454-7998-4f92-bf34-c4b0a262de66	0	20	t	3da66225-d04c-489b-9503-0a71f50d0de7	\N
6555c3ac-d5bc-438c-aa96-d87725bfdf08	\N	idp-email-verification	b438138c-504f-4895-bc39-d44717b59327	3da66225-d04c-489b-9503-0a71f50d0de7	2	10	f	\N	\N
93f176e6-a2b2-4ef7-965f-9a89892649e0	\N	\N	b438138c-504f-4895-bc39-d44717b59327	3da66225-d04c-489b-9503-0a71f50d0de7	2	20	t	d9e92df6-28fb-4f6a-a85a-0b308c3eb8d6	\N
0f19ca90-a703-43a7-b871-3c8a5d2b5bed	\N	idp-username-password-form	b438138c-504f-4895-bc39-d44717b59327	d9e92df6-28fb-4f6a-a85a-0b308c3eb8d6	0	10	f	\N	\N
e578ac48-7f53-40bf-aad9-3a613904d1a2	\N	\N	b438138c-504f-4895-bc39-d44717b59327	d9e92df6-28fb-4f6a-a85a-0b308c3eb8d6	1	20	t	1213c5ba-b832-437e-a564-044449f236af	\N
7f328b92-2408-40d1-9f92-da58ab718eaf	\N	conditional-user-configured	b438138c-504f-4895-bc39-d44717b59327	1213c5ba-b832-437e-a564-044449f236af	0	10	f	\N	\N
235e90f1-cff3-4af1-ab39-5a99c19c9bad	\N	auth-otp-form	b438138c-504f-4895-bc39-d44717b59327	1213c5ba-b832-437e-a564-044449f236af	2	20	f	\N	\N
d9729ce8-64bb-41c5-a2bc-6d980d7a631c	\N	webauthn-authenticator	b438138c-504f-4895-bc39-d44717b59327	1213c5ba-b832-437e-a564-044449f236af	3	30	f	\N	\N
4b3d437e-7fa6-42e9-a7f1-9dacc5480e42	\N	auth-recovery-authn-code-form	b438138c-504f-4895-bc39-d44717b59327	1213c5ba-b832-437e-a564-044449f236af	3	40	f	\N	\N
81161b23-eb85-4f8c-af41-f7e3711d0b9d	\N	http-basic-authenticator	b438138c-504f-4895-bc39-d44717b59327	cf4365e3-705d-4c82-b4c3-860e49024159	0	10	f	\N	\N
53aaeec1-e4e8-4758-9fbb-9743908f6d18	\N	docker-http-basic-authenticator	b438138c-504f-4895-bc39-d44717b59327	7c60623f-8232-400d-b9b1-b1a2aad8547e	0	10	f	\N	\N
d084f8df-fe34-4b34-be1d-adba5a9f1866	\N	idp-email-verification	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	dca62b1f-e764-4007-b9ef-b8f0e703bd00	2	10	f	\N	\N
3e250e2b-97db-4561-a513-2d88c723bcbf	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	dca62b1f-e764-4007-b9ef-b8f0e703bd00	2	20	t	18af4f01-e445-45a7-98a9-b8480a54015d	\N
225f412d-424d-4ced-bee8-df473f6b418a	\N	conditional-user-configured	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	70a17c71-1e0e-4dcf-913e-e0b929c49a33	0	10	f	\N	\N
acee155d-d70d-4496-8fdf-001c718db82a	\N	auth-otp-form	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	70a17c71-1e0e-4dcf-913e-e0b929c49a33	0	20	f	\N	\N
ed4159c5-d2b4-4787-9f84-ea6ce20802bb	\N	conditional-user-configured	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	1892e93c-fde1-4fd3-b2dd-a1edd45ecd26	0	10	f	\N	\N
a25308ce-b5d8-463a-9456-dc57a3621f24	\N	organization	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	1892e93c-fde1-4fd3-b2dd-a1edd45ecd26	2	20	f	\N	\N
a3479a75-f148-4ced-ae86-26c920fc547f	\N	conditional-user-configured	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	58ccdd5d-9e47-42b0-b8d7-b89a064daa69	0	10	f	\N	\N
0afa2ff0-4ea9-41d4-b458-51a3d4068c7c	\N	direct-grant-validate-otp	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	58ccdd5d-9e47-42b0-b8d7-b89a064daa69	0	20	f	\N	\N
db382a4b-3bc1-49e7-8368-396af891dd00	\N	conditional-user-configured	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	8ee8d001-4c41-48e3-b3d7-463fd007ac2b	0	10	f	\N	\N
1a1dcb72-0db2-40e8-b685-7841f9432e91	\N	idp-add-organization-member	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	8ee8d001-4c41-48e3-b3d7-463fd007ac2b	0	20	f	\N	\N
909a4c46-47d5-441f-aa13-15eeb26c7545	\N	conditional-user-configured	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	bc9b8394-ac12-468a-a3dc-55ec4bc3e0b2	0	10	f	\N	\N
beffb95e-ce87-496b-9d87-e5f67b3f84f7	\N	auth-otp-form	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	bc9b8394-ac12-468a-a3dc-55ec4bc3e0b2	0	20	f	\N	\N
a6b7d496-42b7-40fb-9f91-6da05d8206a3	\N	idp-confirm-link	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	e156e078-07ed-4bec-ad4c-4f19508ea595	0	10	f	\N	\N
65543974-9071-4e85-b13b-14c9411714a3	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	e156e078-07ed-4bec-ad4c-4f19508ea595	0	20	t	dca62b1f-e764-4007-b9ef-b8f0e703bd00	\N
f0fd9c04-0571-4007-a0af-f3478f26c4be	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	e11b4410-776d-4f45-9da6-3d50fd0ecb57	1	10	t	1892e93c-fde1-4fd3-b2dd-a1edd45ecd26	\N
84e0b76a-b967-4c01-9e2c-c7f84d03f840	\N	conditional-user-configured	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	24080a19-f1bd-451a-bbb5-af9f3d658205	0	10	f	\N	\N
f2805a6d-5b01-4b80-a7d8-527ce79d783b	\N	reset-otp	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	24080a19-f1bd-451a-bbb5-af9f3d658205	0	20	f	\N	\N
4a53338a-33d1-41ec-bb9c-bfc99e5f1970	\N	idp-create-user-if-unique	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	4abee144-ad13-44f6-9b23-b8b11d5e8149	2	10	f	\N	842f0ae4-5ec3-438f-8567-714ee5373efc
8d59853f-0a11-473a-8501-7780a904146b	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	4abee144-ad13-44f6-9b23-b8b11d5e8149	2	20	t	e156e078-07ed-4bec-ad4c-4f19508ea595	\N
27801a98-9a24-4c3c-9381-57da5baee6ea	\N	idp-username-password-form	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	18af4f01-e445-45a7-98a9-b8480a54015d	0	10	f	\N	\N
7ec53948-598e-46d7-b4a6-73b6fca83c61	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	18af4f01-e445-45a7-98a9-b8480a54015d	1	20	t	bc9b8394-ac12-468a-a3dc-55ec4bc3e0b2	\N
fc37f979-5a82-4731-8506-87d4c2644497	\N	auth-cookie	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	11d4a136-08ef-4185-879e-20a7e5e71ea0	2	10	f	\N	\N
e0df925f-63ec-47d6-892f-105e402174ed	\N	auth-spnego	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	11d4a136-08ef-4185-879e-20a7e5e71ea0	3	20	f	\N	\N
20c57377-5ca6-4281-8a20-516b1c1fc382	\N	identity-provider-redirector	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	11d4a136-08ef-4185-879e-20a7e5e71ea0	2	25	f	\N	\N
be0c5fa5-0a10-4639-a596-f084da4d137b	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	11d4a136-08ef-4185-879e-20a7e5e71ea0	2	26	t	e11b4410-776d-4f45-9da6-3d50fd0ecb57	\N
5aebd13e-ccc8-45c3-8341-a053db6fa42e	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	11d4a136-08ef-4185-879e-20a7e5e71ea0	2	30	t	8340e02e-4a7f-4979-b060-e62241f68034	\N
6bbc7e87-2e4b-4b9a-96d4-2a62d20c85d3	\N	client-secret	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	f7ba0e0f-7be0-458e-aae1-6e59a6b35aec	2	10	f	\N	\N
0576e774-584c-4431-b2e8-cc8cb911c256	\N	client-jwt	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	f7ba0e0f-7be0-458e-aae1-6e59a6b35aec	2	20	f	\N	\N
7467562f-9e82-4794-89f9-fab34d47d020	\N	client-secret-jwt	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	f7ba0e0f-7be0-458e-aae1-6e59a6b35aec	2	30	f	\N	\N
950fd192-a743-4cd1-bef3-fc0b25f5ee6e	\N	client-x509	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	f7ba0e0f-7be0-458e-aae1-6e59a6b35aec	2	40	f	\N	\N
5756b88f-a981-42cc-ae6b-e099da3f9b09	\N	direct-grant-validate-username	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	8de5f3d7-1fd9-4859-97bb-5859d47db91c	0	10	f	\N	\N
c7512b1a-541d-4e12-bdc4-a45d9fa64364	\N	direct-grant-validate-password	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	8de5f3d7-1fd9-4859-97bb-5859d47db91c	0	20	f	\N	\N
03d9dc49-00a1-4d98-8f89-ce9068d9ccce	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	8de5f3d7-1fd9-4859-97bb-5859d47db91c	1	30	t	58ccdd5d-9e47-42b0-b8d7-b89a064daa69	\N
fbb0a37e-f99e-4fe9-a7b7-f98fed712f26	\N	docker-http-basic-authenticator	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	478c5259-862d-4db9-a2ea-bd0887d86ee9	0	10	f	\N	\N
41bfbd2f-a9f1-4af0-a1a1-b3e370a7e3eb	\N	idp-review-profile	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2a26e08e-2278-4d56-931b-12601113607f	0	10	f	\N	e91259f8-3397-41af-87d9-78354e82655d
b8d9cd51-26d2-4ab0-ba9a-ade5c3d13a90	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2a26e08e-2278-4d56-931b-12601113607f	0	20	t	4abee144-ad13-44f6-9b23-b8b11d5e8149	\N
a08bf811-f917-4263-8161-a64aa6146e8c	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2a26e08e-2278-4d56-931b-12601113607f	1	50	t	8ee8d001-4c41-48e3-b3d7-463fd007ac2b	\N
ab155705-fa61-4d38-b819-d010789983ca	\N	auth-username-password-form	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	8340e02e-4a7f-4979-b060-e62241f68034	0	10	f	\N	\N
f3b04a03-27b4-4941-8a89-8db179f1feae	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	8340e02e-4a7f-4979-b060-e62241f68034	1	20	t	70a17c71-1e0e-4dcf-913e-e0b929c49a33	\N
ed38d7af-24a4-4b8f-887b-35a31a6af1e7	\N	registration-page-form	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	58806ca6-b5ca-4f7f-9550-a8cec9066c73	0	10	t	5f09c312-15b0-4ae2-9f37-162501b73124	\N
0230411e-a725-4dbb-a93f-a64a43871f04	\N	registration-user-creation	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	5f09c312-15b0-4ae2-9f37-162501b73124	0	20	f	\N	\N
76e6d01c-4c98-4d0e-8084-468ad9ded243	\N	registration-password-action	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	5f09c312-15b0-4ae2-9f37-162501b73124	0	50	f	\N	\N
cb30033e-9421-4ba1-9f8b-a46587971485	\N	registration-recaptcha-action	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	5f09c312-15b0-4ae2-9f37-162501b73124	3	60	f	\N	\N
9c086a48-130a-4846-a5e6-6963dbf58a4b	\N	registration-terms-and-conditions	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	5f09c312-15b0-4ae2-9f37-162501b73124	3	70	f	\N	\N
8d1b6904-df50-4585-adde-6f9239d4ced9	\N	reset-credentials-choose-user	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	1c24920f-adcf-403f-aeee-622e2218c632	0	10	f	\N	\N
7aabb8a3-b142-44b6-af15-1dad7cd3af7d	\N	reset-credential-email	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	1c24920f-adcf-403f-aeee-622e2218c632	0	20	f	\N	\N
3e003e39-c055-40b9-bff8-27fd7f0744be	\N	reset-password	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	1c24920f-adcf-403f-aeee-622e2218c632	0	30	f	\N	\N
a8a3893b-1017-4c86-a410-8f6dcf336b8c	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	1c24920f-adcf-403f-aeee-622e2218c632	1	40	t	24080a19-f1bd-451a-bbb5-af9f3d658205	\N
a5970a48-12b5-4266-8491-e82a3873b0ef	\N	http-basic-authenticator	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	12ce7ac1-6e95-4ef2-a19f-06099f6fb78b	0	10	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
b6ba99d2-5883-4a3c-b784-c3e943194864	browser	Browser based authentication	b438138c-504f-4895-bc39-d44717b59327	basic-flow	t	t
368a687b-972c-461e-972c-e1446c8ff07f	forms	Username, password, otp and other auth forms.	b438138c-504f-4895-bc39-d44717b59327	basic-flow	f	t
65d8a787-3921-45bb-8f6c-1ce4787c3f3b	Browser - Conditional 2FA	Flow to determine if any 2FA is required for the authentication	b438138c-504f-4895-bc39-d44717b59327	basic-flow	f	t
577dba76-0d2c-4fe2-af5d-15a8c0261f39	direct grant	OpenID Connect Resource Owner Grant	b438138c-504f-4895-bc39-d44717b59327	basic-flow	t	t
c167f457-b9bc-437d-a09e-5909ee98749c	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	b438138c-504f-4895-bc39-d44717b59327	basic-flow	f	t
2b2b334a-1572-4f24-aee4-033e5f2a9e22	registration	Registration flow	b438138c-504f-4895-bc39-d44717b59327	basic-flow	t	t
b4054718-7264-43e1-832f-be07a7b29a84	registration form	Registration form	b438138c-504f-4895-bc39-d44717b59327	form-flow	f	t
27ee01e9-fcf9-4177-bec2-404aef9d5879	reset credentials	Reset credentials for a user if they forgot their password or something	b438138c-504f-4895-bc39-d44717b59327	basic-flow	t	t
94a49b9e-9807-4874-a18c-25c06bd31624	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	b438138c-504f-4895-bc39-d44717b59327	basic-flow	f	t
406ec97c-1681-463e-9496-8e966798cb5f	clients	Base authentication for clients	b438138c-504f-4895-bc39-d44717b59327	client-flow	t	t
3236e8e9-efe1-4d6c-8424-f3a54e2d1a75	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	b438138c-504f-4895-bc39-d44717b59327	basic-flow	t	t
25ad4e70-88a2-4714-a5bb-5133fc3d576c	User creation or linking	Flow for the existing/non-existing user alternatives	b438138c-504f-4895-bc39-d44717b59327	basic-flow	f	t
5254a454-7998-4f92-bf34-c4b0a262de66	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	b438138c-504f-4895-bc39-d44717b59327	basic-flow	f	t
3da66225-d04c-489b-9503-0a71f50d0de7	Account verification options	Method with which to verity the existing account	b438138c-504f-4895-bc39-d44717b59327	basic-flow	f	t
d9e92df6-28fb-4f6a-a85a-0b308c3eb8d6	Verify Existing Account by Re-authentication	Reauthentication of existing account	b438138c-504f-4895-bc39-d44717b59327	basic-flow	f	t
1213c5ba-b832-437e-a564-044449f236af	First broker login - Conditional 2FA	Flow to determine if any 2FA is required for the authentication	b438138c-504f-4895-bc39-d44717b59327	basic-flow	f	t
cf4365e3-705d-4c82-b4c3-860e49024159	saml ecp	SAML ECP Profile Authentication Flow	b438138c-504f-4895-bc39-d44717b59327	basic-flow	t	t
7c60623f-8232-400d-b9b1-b1a2aad8547e	docker auth	Used by Docker clients to authenticate against the IDP	b438138c-504f-4895-bc39-d44717b59327	basic-flow	t	t
dca62b1f-e764-4007-b9ef-b8f0e703bd00	Account verification options	Method with which to verity the existing account	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
70a17c71-1e0e-4dcf-913e-e0b929c49a33	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
1892e93c-fde1-4fd3-b2dd-a1edd45ecd26	Browser - Conditional Organization	Flow to determine if the organization identity-first login is to be used	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
58ccdd5d-9e47-42b0-b8d7-b89a064daa69	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
8ee8d001-4c41-48e3-b3d7-463fd007ac2b	First Broker Login - Conditional Organization	Flow to determine if the authenticator that adds organization members is to be used	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
bc9b8394-ac12-468a-a3dc-55ec4bc3e0b2	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
e156e078-07ed-4bec-ad4c-4f19508ea595	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
e11b4410-776d-4f45-9da6-3d50fd0ecb57	Organization	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
24080a19-f1bd-451a-bbb5-af9f3d658205	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
4abee144-ad13-44f6-9b23-b8b11d5e8149	User creation or linking	Flow for the existing/non-existing user alternatives	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
18af4f01-e445-45a7-98a9-b8480a54015d	Verify Existing Account by Re-authentication	Reauthentication of existing account	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
11d4a136-08ef-4185-879e-20a7e5e71ea0	browser	Browser based authentication	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	t	t
f7ba0e0f-7be0-458e-aae1-6e59a6b35aec	clients	Base authentication for clients	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	client-flow	t	t
8de5f3d7-1fd9-4859-97bb-5859d47db91c	direct grant	OpenID Connect Resource Owner Grant	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	t	t
478c5259-862d-4db9-a2ea-bd0887d86ee9	docker auth	Used by Docker clients to authenticate against the IDP	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	t	t
2a26e08e-2278-4d56-931b-12601113607f	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	t	t
8340e02e-4a7f-4979-b060-e62241f68034	forms	Username, password, otp and other auth forms.	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
58806ca6-b5ca-4f7f-9550-a8cec9066c73	registration	Registration flow	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	t	t
5f09c312-15b0-4ae2-9f37-162501b73124	registration form	Registration form	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	form-flow	f	t
1c24920f-adcf-403f-aeee-622e2218c632	reset credentials	Reset credentials for a user if they forgot their password or something	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	t	t
12ce7ac1-6e95-4ef2-a19f-06099f6fb78b	saml ecp	SAML ECP Profile Authentication Flow	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	t	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
740ad9c5-3fac-4077-9e9b-21bd8e3d98c1	review profile config	b438138c-504f-4895-bc39-d44717b59327
27b13851-2a66-4ba1-90ef-b50ad807171b	create unique user config	b438138c-504f-4895-bc39-d44717b59327
842f0ae4-5ec3-438f-8567-714ee5373efc	create unique user config	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc
e91259f8-3397-41af-87d9-78354e82655d	review profile config	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
27b13851-2a66-4ba1-90ef-b50ad807171b	false	require.password.update.after.registration
740ad9c5-3fac-4077-9e9b-21bd8e3d98c1	missing	update.profile.on.first.login
842f0ae4-5ec3-438f-8567-714ee5373efc	false	require.password.update.after.registration
e91259f8-3397-41af-87d9-78354e82655d	missing	update.profile.on.first.login
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	t	f	master-realm	0	f	\N	\N	t	\N	f	b438138c-504f-4895-bc39-d44717b59327	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
adaa41f0-3a6d-4d36-afff-d00455b42e38	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	b438138c-504f-4895-bc39-d44717b59327	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
e549e6ec-8bb9-4897-ae6b-89e65040fc57	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	b438138c-504f-4895-bc39-d44717b59327	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
84e89c17-22ae-44fb-8383-6b6a552ce599	t	f	broker	0	f	\N	\N	t	\N	f	b438138c-504f-4895-bc39-d44717b59327	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
e5a66eb0-ba52-4ce5-9f3a-d7ad118df926	t	t	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	b438138c-504f-4895-bc39-d44717b59327	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
c4162f2d-24d5-4400-99ce-b7bcd4d9b48f	t	t	admin-cli	0	t	\N	\N	f	\N	f	b438138c-504f-4895-bc39-d44717b59327	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	t	f	nextjs-dashboard-realm	0	f	\N	\N	t	\N	f	b438138c-504f-4895-bc39-d44717b59327	\N	0	f	f	nextjs-dashboard Realm	f	client-secret	\N	\N	\N	t	f	f	f
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	t	f	account	0	t	\N	/realms/nextjs-dashboard/account/	f	\N	f	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
6594bd92-c078-437d-aa19-32810411fe71	t	f	account-console	0	t	\N	/realms/nextjs-dashboard/account/	f	\N	f	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	t	t	admin-cli	0	t	\N	\N	f	\N	f	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
ea8fbaa3-b5f1-4548-acef-7f4622c53980	t	f	broker	0	f	\N	\N	t	\N	f	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	t	t	parkigo	0	f	EizZfQy12vFin9Nzty0ro6tGQockUbBl	\N	f	http://localhost:3000	f	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	openid-connect	-1	f	f	\N	f	client-secret	http://localhost:3000	\N	\N	t	f	t	f
2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	f	realm-management	0	f	\N	\N	t	\N	f	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f
b323fd36-7155-40a7-9eb1-94d315656e84	t	t	security-admin-console	0	t	\N	/admin/nextjs-dashboard/console/	f	\N	f	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.client_attributes (client_id, name, value) FROM stdin;
adaa41f0-3a6d-4d36-afff-d00455b42e38	post.logout.redirect.uris	+
e549e6ec-8bb9-4897-ae6b-89e65040fc57	post.logout.redirect.uris	+
e549e6ec-8bb9-4897-ae6b-89e65040fc57	pkce.code.challenge.method	S256
e5a66eb0-ba52-4ce5-9f3a-d7ad118df926	post.logout.redirect.uris	+
e5a66eb0-ba52-4ce5-9f3a-d7ad118df926	pkce.code.challenge.method	S256
e5a66eb0-ba52-4ce5-9f3a-d7ad118df926	client.use.lightweight.access.token.enabled	true
c4162f2d-24d5-4400-99ce-b7bcd4d9b48f	client.use.lightweight.access.token.enabled	true
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	realm_client	false
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	post.logout.redirect.uris	+
6594bd92-c078-437d-aa19-32810411fe71	realm_client	false
6594bd92-c078-437d-aa19-32810411fe71	post.logout.redirect.uris	+
6594bd92-c078-437d-aa19-32810411fe71	pkce.code.challenge.method	S256
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	realm_client	false
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	client.use.lightweight.access.token.enabled	true
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	post.logout.redirect.uris	+
ea8fbaa3-b5f1-4548-acef-7f4622c53980	realm_client	true
ea8fbaa3-b5f1-4548-acef-7f4622c53980	post.logout.redirect.uris	+
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	realm_client	false
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	post.logout.redirect.uris	+
2aceca6f-245d-4ffe-80a0-efc46198a4f2	realm_client	true
2aceca6f-245d-4ffe-80a0-efc46198a4f2	post.logout.redirect.uris	+
b323fd36-7155-40a7-9eb1-94d315656e84	realm_client	false
b323fd36-7155-40a7-9eb1-94d315656e84	client.use.lightweight.access.token.enabled	true
b323fd36-7155-40a7-9eb1-94d315656e84	post.logout.redirect.uris	+
b323fd36-7155-40a7-9eb1-94d315656e84	pkce.code.challenge.method	S256
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
7fe79f44-d68f-4337-acb6-e000d1159d2a	offline_access	b438138c-504f-4895-bc39-d44717b59327	OpenID Connect built-in scope: offline_access	openid-connect
c056cd04-2f6d-40fa-9c2c-3a771cc97cb8	role_list	b438138c-504f-4895-bc39-d44717b59327	SAML role list	saml
7e71e852-5f73-4c26-81a4-7973ce437597	saml_organization	b438138c-504f-4895-bc39-d44717b59327	Organization Membership	saml
0430d4e1-e12e-4417-8864-5c6e31e6f4c1	profile	b438138c-504f-4895-bc39-d44717b59327	OpenID Connect built-in scope: profile	openid-connect
e88b8b0e-70a6-42e8-a740-ab3326601c75	email	b438138c-504f-4895-bc39-d44717b59327	OpenID Connect built-in scope: email	openid-connect
0a3f3395-1539-4523-918a-7bbdd650e256	address	b438138c-504f-4895-bc39-d44717b59327	OpenID Connect built-in scope: address	openid-connect
d90bb3c9-61cd-46d4-9da6-44525a8396e0	phone	b438138c-504f-4895-bc39-d44717b59327	OpenID Connect built-in scope: phone	openid-connect
59b27656-1314-4e09-b458-98778fccc9d1	roles	b438138c-504f-4895-bc39-d44717b59327	OpenID Connect scope for add user roles to the access token	openid-connect
b1b2fd01-adbc-4974-8dba-eda2dae12865	web-origins	b438138c-504f-4895-bc39-d44717b59327	OpenID Connect scope for add allowed web origins to the access token	openid-connect
25edf6ba-0d33-48ea-9458-585dbf7a0379	microprofile-jwt	b438138c-504f-4895-bc39-d44717b59327	Microprofile - JWT built-in scope	openid-connect
454d585d-dd7c-4345-89ff-9dd0ab17d8a4	acr	b438138c-504f-4895-bc39-d44717b59327	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
b7b320a4-771c-4f3c-bf7f-5c1691f791da	basic	b438138c-504f-4895-bc39-d44717b59327	OpenID Connect scope for add all basic claims to the token	openid-connect
44028f5a-5bca-433d-9ff0-79f82cbd3caa	service_account	b438138c-504f-4895-bc39-d44717b59327	Specific scope for a client enabled for service accounts	openid-connect
557cdfe0-7c65-4218-9de6-25a29f429f55	organization	b438138c-504f-4895-bc39-d44717b59327	Additional claims about the organization a subject belongs to	openid-connect
fa609b0e-925f-4251-a437-291fdf9d71a1	acr	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
c6917b9d-3aae-48d7-887d-9d1f1c3c50a0	service_account	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	Specific scope for a client enabled for service accounts	openid-connect
411c662c-cd97-4f46-a8bc-7a4f473f7cfb	organization	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	Additional claims about the organization a subject belongs to	openid-connect
178dac49-f258-4a20-a227-baca55f97d8d	profile	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	OpenID Connect built-in scope: profile	openid-connect
34aa2dce-16c8-457d-9178-bb836e027ca2	offline_access	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	OpenID Connect built-in scope: offline_access	openid-connect
51061315-4b70-49de-b605-55a40d6ab93f	basic	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	OpenID Connect scope for add all basic claims to the token	openid-connect
b9c6ce23-7173-41dd-be46-cdfb74fec18a	email	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	OpenID Connect built-in scope: email	openid-connect
5b0a8700-85e8-46b9-a764-6cd2f85d8846	roles	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	OpenID Connect scope for add user roles to the access token	openid-connect
ef14b883-04bf-4557-be1a-231b99162857	web-origins	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	OpenID Connect scope for add allowed web origins to the access token	openid-connect
1ed0d4c4-0720-4e69-be21-091241d3c574	address	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	OpenID Connect built-in scope: address	openid-connect
2977881a-44c7-40ba-aa11-afb0a05ec0b2	role_list	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	SAML role list	saml
49ab1a06-38f4-4c32-868e-48b61022c00f	phone	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	OpenID Connect built-in scope: phone	openid-connect
813c8c55-74e0-494f-9682-23d026340f42	microprofile-jwt	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	Microprofile - JWT built-in scope	openid-connect
8c468075-525e-4ab3-94ec-ba4dc437c24f	saml_organization	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	Organization Membership	saml
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
7fe79f44-d68f-4337-acb6-e000d1159d2a	true	display.on.consent.screen
7fe79f44-d68f-4337-acb6-e000d1159d2a	${offlineAccessScopeConsentText}	consent.screen.text
c056cd04-2f6d-40fa-9c2c-3a771cc97cb8	true	display.on.consent.screen
c056cd04-2f6d-40fa-9c2c-3a771cc97cb8	${samlRoleListScopeConsentText}	consent.screen.text
7e71e852-5f73-4c26-81a4-7973ce437597	false	display.on.consent.screen
0430d4e1-e12e-4417-8864-5c6e31e6f4c1	true	display.on.consent.screen
0430d4e1-e12e-4417-8864-5c6e31e6f4c1	${profileScopeConsentText}	consent.screen.text
0430d4e1-e12e-4417-8864-5c6e31e6f4c1	true	include.in.token.scope
e88b8b0e-70a6-42e8-a740-ab3326601c75	true	display.on.consent.screen
e88b8b0e-70a6-42e8-a740-ab3326601c75	${emailScopeConsentText}	consent.screen.text
e88b8b0e-70a6-42e8-a740-ab3326601c75	true	include.in.token.scope
0a3f3395-1539-4523-918a-7bbdd650e256	true	display.on.consent.screen
0a3f3395-1539-4523-918a-7bbdd650e256	${addressScopeConsentText}	consent.screen.text
0a3f3395-1539-4523-918a-7bbdd650e256	true	include.in.token.scope
d90bb3c9-61cd-46d4-9da6-44525a8396e0	true	display.on.consent.screen
d90bb3c9-61cd-46d4-9da6-44525a8396e0	${phoneScopeConsentText}	consent.screen.text
d90bb3c9-61cd-46d4-9da6-44525a8396e0	true	include.in.token.scope
59b27656-1314-4e09-b458-98778fccc9d1	true	display.on.consent.screen
59b27656-1314-4e09-b458-98778fccc9d1	${rolesScopeConsentText}	consent.screen.text
59b27656-1314-4e09-b458-98778fccc9d1	false	include.in.token.scope
b1b2fd01-adbc-4974-8dba-eda2dae12865	false	display.on.consent.screen
b1b2fd01-adbc-4974-8dba-eda2dae12865		consent.screen.text
b1b2fd01-adbc-4974-8dba-eda2dae12865	false	include.in.token.scope
25edf6ba-0d33-48ea-9458-585dbf7a0379	false	display.on.consent.screen
25edf6ba-0d33-48ea-9458-585dbf7a0379	true	include.in.token.scope
454d585d-dd7c-4345-89ff-9dd0ab17d8a4	false	display.on.consent.screen
454d585d-dd7c-4345-89ff-9dd0ab17d8a4	false	include.in.token.scope
b7b320a4-771c-4f3c-bf7f-5c1691f791da	false	display.on.consent.screen
b7b320a4-771c-4f3c-bf7f-5c1691f791da	false	include.in.token.scope
44028f5a-5bca-433d-9ff0-79f82cbd3caa	false	display.on.consent.screen
44028f5a-5bca-433d-9ff0-79f82cbd3caa	false	include.in.token.scope
557cdfe0-7c65-4218-9de6-25a29f429f55	true	display.on.consent.screen
557cdfe0-7c65-4218-9de6-25a29f429f55	${organizationScopeConsentText}	consent.screen.text
557cdfe0-7c65-4218-9de6-25a29f429f55	true	include.in.token.scope
fa609b0e-925f-4251-a437-291fdf9d71a1	false	include.in.token.scope
fa609b0e-925f-4251-a437-291fdf9d71a1	false	display.on.consent.screen
c6917b9d-3aae-48d7-887d-9d1f1c3c50a0	false	include.in.token.scope
c6917b9d-3aae-48d7-887d-9d1f1c3c50a0	false	display.on.consent.screen
411c662c-cd97-4f46-a8bc-7a4f473f7cfb	true	include.in.token.scope
411c662c-cd97-4f46-a8bc-7a4f473f7cfb	${organizationScopeConsentText}	consent.screen.text
411c662c-cd97-4f46-a8bc-7a4f473f7cfb	true	display.on.consent.screen
178dac49-f258-4a20-a227-baca55f97d8d	true	include.in.token.scope
178dac49-f258-4a20-a227-baca55f97d8d	${profileScopeConsentText}	consent.screen.text
178dac49-f258-4a20-a227-baca55f97d8d	true	display.on.consent.screen
34aa2dce-16c8-457d-9178-bb836e027ca2	${offlineAccessScopeConsentText}	consent.screen.text
34aa2dce-16c8-457d-9178-bb836e027ca2	true	display.on.consent.screen
51061315-4b70-49de-b605-55a40d6ab93f	false	include.in.token.scope
51061315-4b70-49de-b605-55a40d6ab93f	false	display.on.consent.screen
b9c6ce23-7173-41dd-be46-cdfb74fec18a	true	include.in.token.scope
b9c6ce23-7173-41dd-be46-cdfb74fec18a	${emailScopeConsentText}	consent.screen.text
b9c6ce23-7173-41dd-be46-cdfb74fec18a	true	display.on.consent.screen
5b0a8700-85e8-46b9-a764-6cd2f85d8846	false	include.in.token.scope
5b0a8700-85e8-46b9-a764-6cd2f85d8846	${rolesScopeConsentText}	consent.screen.text
5b0a8700-85e8-46b9-a764-6cd2f85d8846	true	display.on.consent.screen
ef14b883-04bf-4557-be1a-231b99162857	false	include.in.token.scope
ef14b883-04bf-4557-be1a-231b99162857		consent.screen.text
ef14b883-04bf-4557-be1a-231b99162857	false	display.on.consent.screen
1ed0d4c4-0720-4e69-be21-091241d3c574	true	include.in.token.scope
1ed0d4c4-0720-4e69-be21-091241d3c574	${addressScopeConsentText}	consent.screen.text
1ed0d4c4-0720-4e69-be21-091241d3c574	true	display.on.consent.screen
2977881a-44c7-40ba-aa11-afb0a05ec0b2	${samlRoleListScopeConsentText}	consent.screen.text
2977881a-44c7-40ba-aa11-afb0a05ec0b2	true	display.on.consent.screen
49ab1a06-38f4-4c32-868e-48b61022c00f	true	include.in.token.scope
49ab1a06-38f4-4c32-868e-48b61022c00f	${phoneScopeConsentText}	consent.screen.text
49ab1a06-38f4-4c32-868e-48b61022c00f	true	display.on.consent.screen
813c8c55-74e0-494f-9682-23d026340f42	true	include.in.token.scope
813c8c55-74e0-494f-9682-23d026340f42	false	display.on.consent.screen
8c468075-525e-4ab3-94ec-ba4dc437c24f	false	display.on.consent.screen
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
adaa41f0-3a6d-4d36-afff-d00455b42e38	b1b2fd01-adbc-4974-8dba-eda2dae12865	t
adaa41f0-3a6d-4d36-afff-d00455b42e38	454d585d-dd7c-4345-89ff-9dd0ab17d8a4	t
adaa41f0-3a6d-4d36-afff-d00455b42e38	0430d4e1-e12e-4417-8864-5c6e31e6f4c1	t
adaa41f0-3a6d-4d36-afff-d00455b42e38	b7b320a4-771c-4f3c-bf7f-5c1691f791da	t
adaa41f0-3a6d-4d36-afff-d00455b42e38	e88b8b0e-70a6-42e8-a740-ab3326601c75	t
adaa41f0-3a6d-4d36-afff-d00455b42e38	59b27656-1314-4e09-b458-98778fccc9d1	t
adaa41f0-3a6d-4d36-afff-d00455b42e38	d90bb3c9-61cd-46d4-9da6-44525a8396e0	f
adaa41f0-3a6d-4d36-afff-d00455b42e38	25edf6ba-0d33-48ea-9458-585dbf7a0379	f
adaa41f0-3a6d-4d36-afff-d00455b42e38	0a3f3395-1539-4523-918a-7bbdd650e256	f
adaa41f0-3a6d-4d36-afff-d00455b42e38	7fe79f44-d68f-4337-acb6-e000d1159d2a	f
adaa41f0-3a6d-4d36-afff-d00455b42e38	557cdfe0-7c65-4218-9de6-25a29f429f55	f
e549e6ec-8bb9-4897-ae6b-89e65040fc57	b1b2fd01-adbc-4974-8dba-eda2dae12865	t
e549e6ec-8bb9-4897-ae6b-89e65040fc57	454d585d-dd7c-4345-89ff-9dd0ab17d8a4	t
e549e6ec-8bb9-4897-ae6b-89e65040fc57	0430d4e1-e12e-4417-8864-5c6e31e6f4c1	t
e549e6ec-8bb9-4897-ae6b-89e65040fc57	b7b320a4-771c-4f3c-bf7f-5c1691f791da	t
e549e6ec-8bb9-4897-ae6b-89e65040fc57	e88b8b0e-70a6-42e8-a740-ab3326601c75	t
e549e6ec-8bb9-4897-ae6b-89e65040fc57	59b27656-1314-4e09-b458-98778fccc9d1	t
e549e6ec-8bb9-4897-ae6b-89e65040fc57	d90bb3c9-61cd-46d4-9da6-44525a8396e0	f
e549e6ec-8bb9-4897-ae6b-89e65040fc57	25edf6ba-0d33-48ea-9458-585dbf7a0379	f
e549e6ec-8bb9-4897-ae6b-89e65040fc57	0a3f3395-1539-4523-918a-7bbdd650e256	f
e549e6ec-8bb9-4897-ae6b-89e65040fc57	7fe79f44-d68f-4337-acb6-e000d1159d2a	f
e549e6ec-8bb9-4897-ae6b-89e65040fc57	557cdfe0-7c65-4218-9de6-25a29f429f55	f
c4162f2d-24d5-4400-99ce-b7bcd4d9b48f	b1b2fd01-adbc-4974-8dba-eda2dae12865	t
c4162f2d-24d5-4400-99ce-b7bcd4d9b48f	454d585d-dd7c-4345-89ff-9dd0ab17d8a4	t
c4162f2d-24d5-4400-99ce-b7bcd4d9b48f	0430d4e1-e12e-4417-8864-5c6e31e6f4c1	t
c4162f2d-24d5-4400-99ce-b7bcd4d9b48f	b7b320a4-771c-4f3c-bf7f-5c1691f791da	t
c4162f2d-24d5-4400-99ce-b7bcd4d9b48f	e88b8b0e-70a6-42e8-a740-ab3326601c75	t
c4162f2d-24d5-4400-99ce-b7bcd4d9b48f	59b27656-1314-4e09-b458-98778fccc9d1	t
c4162f2d-24d5-4400-99ce-b7bcd4d9b48f	d90bb3c9-61cd-46d4-9da6-44525a8396e0	f
c4162f2d-24d5-4400-99ce-b7bcd4d9b48f	25edf6ba-0d33-48ea-9458-585dbf7a0379	f
c4162f2d-24d5-4400-99ce-b7bcd4d9b48f	0a3f3395-1539-4523-918a-7bbdd650e256	f
c4162f2d-24d5-4400-99ce-b7bcd4d9b48f	7fe79f44-d68f-4337-acb6-e000d1159d2a	f
c4162f2d-24d5-4400-99ce-b7bcd4d9b48f	557cdfe0-7c65-4218-9de6-25a29f429f55	f
84e89c17-22ae-44fb-8383-6b6a552ce599	b1b2fd01-adbc-4974-8dba-eda2dae12865	t
84e89c17-22ae-44fb-8383-6b6a552ce599	454d585d-dd7c-4345-89ff-9dd0ab17d8a4	t
84e89c17-22ae-44fb-8383-6b6a552ce599	0430d4e1-e12e-4417-8864-5c6e31e6f4c1	t
84e89c17-22ae-44fb-8383-6b6a552ce599	b7b320a4-771c-4f3c-bf7f-5c1691f791da	t
84e89c17-22ae-44fb-8383-6b6a552ce599	e88b8b0e-70a6-42e8-a740-ab3326601c75	t
84e89c17-22ae-44fb-8383-6b6a552ce599	59b27656-1314-4e09-b458-98778fccc9d1	t
84e89c17-22ae-44fb-8383-6b6a552ce599	d90bb3c9-61cd-46d4-9da6-44525a8396e0	f
84e89c17-22ae-44fb-8383-6b6a552ce599	25edf6ba-0d33-48ea-9458-585dbf7a0379	f
84e89c17-22ae-44fb-8383-6b6a552ce599	0a3f3395-1539-4523-918a-7bbdd650e256	f
84e89c17-22ae-44fb-8383-6b6a552ce599	7fe79f44-d68f-4337-acb6-e000d1159d2a	f
84e89c17-22ae-44fb-8383-6b6a552ce599	557cdfe0-7c65-4218-9de6-25a29f429f55	f
81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	b1b2fd01-adbc-4974-8dba-eda2dae12865	t
81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	454d585d-dd7c-4345-89ff-9dd0ab17d8a4	t
81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	0430d4e1-e12e-4417-8864-5c6e31e6f4c1	t
81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	b7b320a4-771c-4f3c-bf7f-5c1691f791da	t
81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	e88b8b0e-70a6-42e8-a740-ab3326601c75	t
81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	59b27656-1314-4e09-b458-98778fccc9d1	t
81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	d90bb3c9-61cd-46d4-9da6-44525a8396e0	f
81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	25edf6ba-0d33-48ea-9458-585dbf7a0379	f
81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	0a3f3395-1539-4523-918a-7bbdd650e256	f
81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	7fe79f44-d68f-4337-acb6-e000d1159d2a	f
81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	557cdfe0-7c65-4218-9de6-25a29f429f55	f
e5a66eb0-ba52-4ce5-9f3a-d7ad118df926	b1b2fd01-adbc-4974-8dba-eda2dae12865	t
e5a66eb0-ba52-4ce5-9f3a-d7ad118df926	454d585d-dd7c-4345-89ff-9dd0ab17d8a4	t
e5a66eb0-ba52-4ce5-9f3a-d7ad118df926	0430d4e1-e12e-4417-8864-5c6e31e6f4c1	t
e5a66eb0-ba52-4ce5-9f3a-d7ad118df926	b7b320a4-771c-4f3c-bf7f-5c1691f791da	t
e5a66eb0-ba52-4ce5-9f3a-d7ad118df926	e88b8b0e-70a6-42e8-a740-ab3326601c75	t
e5a66eb0-ba52-4ce5-9f3a-d7ad118df926	59b27656-1314-4e09-b458-98778fccc9d1	t
e5a66eb0-ba52-4ce5-9f3a-d7ad118df926	d90bb3c9-61cd-46d4-9da6-44525a8396e0	f
e5a66eb0-ba52-4ce5-9f3a-d7ad118df926	25edf6ba-0d33-48ea-9458-585dbf7a0379	f
e5a66eb0-ba52-4ce5-9f3a-d7ad118df926	0a3f3395-1539-4523-918a-7bbdd650e256	f
e5a66eb0-ba52-4ce5-9f3a-d7ad118df926	7fe79f44-d68f-4337-acb6-e000d1159d2a	f
e5a66eb0-ba52-4ce5-9f3a-d7ad118df926	557cdfe0-7c65-4218-9de6-25a29f429f55	f
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	ef14b883-04bf-4557-be1a-231b99162857	t
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	fa609b0e-925f-4251-a437-291fdf9d71a1	t
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	5b0a8700-85e8-46b9-a764-6cd2f85d8846	t
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	178dac49-f258-4a20-a227-baca55f97d8d	t
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	51061315-4b70-49de-b605-55a40d6ab93f	t
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	b9c6ce23-7173-41dd-be46-cdfb74fec18a	t
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	1ed0d4c4-0720-4e69-be21-091241d3c574	f
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	49ab1a06-38f4-4c32-868e-48b61022c00f	f
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	411c662c-cd97-4f46-a8bc-7a4f473f7cfb	f
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	34aa2dce-16c8-457d-9178-bb836e027ca2	f
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	813c8c55-74e0-494f-9682-23d026340f42	f
6594bd92-c078-437d-aa19-32810411fe71	ef14b883-04bf-4557-be1a-231b99162857	t
6594bd92-c078-437d-aa19-32810411fe71	fa609b0e-925f-4251-a437-291fdf9d71a1	t
6594bd92-c078-437d-aa19-32810411fe71	5b0a8700-85e8-46b9-a764-6cd2f85d8846	t
6594bd92-c078-437d-aa19-32810411fe71	178dac49-f258-4a20-a227-baca55f97d8d	t
6594bd92-c078-437d-aa19-32810411fe71	51061315-4b70-49de-b605-55a40d6ab93f	t
6594bd92-c078-437d-aa19-32810411fe71	b9c6ce23-7173-41dd-be46-cdfb74fec18a	t
6594bd92-c078-437d-aa19-32810411fe71	1ed0d4c4-0720-4e69-be21-091241d3c574	f
6594bd92-c078-437d-aa19-32810411fe71	49ab1a06-38f4-4c32-868e-48b61022c00f	f
6594bd92-c078-437d-aa19-32810411fe71	411c662c-cd97-4f46-a8bc-7a4f473f7cfb	f
6594bd92-c078-437d-aa19-32810411fe71	34aa2dce-16c8-457d-9178-bb836e027ca2	f
6594bd92-c078-437d-aa19-32810411fe71	813c8c55-74e0-494f-9682-23d026340f42	f
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	ef14b883-04bf-4557-be1a-231b99162857	t
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	fa609b0e-925f-4251-a437-291fdf9d71a1	t
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	5b0a8700-85e8-46b9-a764-6cd2f85d8846	t
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	178dac49-f258-4a20-a227-baca55f97d8d	t
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	51061315-4b70-49de-b605-55a40d6ab93f	t
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	b9c6ce23-7173-41dd-be46-cdfb74fec18a	t
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	1ed0d4c4-0720-4e69-be21-091241d3c574	f
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	49ab1a06-38f4-4c32-868e-48b61022c00f	f
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	411c662c-cd97-4f46-a8bc-7a4f473f7cfb	f
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	34aa2dce-16c8-457d-9178-bb836e027ca2	f
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	813c8c55-74e0-494f-9682-23d026340f42	f
ea8fbaa3-b5f1-4548-acef-7f4622c53980	ef14b883-04bf-4557-be1a-231b99162857	t
ea8fbaa3-b5f1-4548-acef-7f4622c53980	fa609b0e-925f-4251-a437-291fdf9d71a1	t
ea8fbaa3-b5f1-4548-acef-7f4622c53980	5b0a8700-85e8-46b9-a764-6cd2f85d8846	t
ea8fbaa3-b5f1-4548-acef-7f4622c53980	178dac49-f258-4a20-a227-baca55f97d8d	t
ea8fbaa3-b5f1-4548-acef-7f4622c53980	51061315-4b70-49de-b605-55a40d6ab93f	t
ea8fbaa3-b5f1-4548-acef-7f4622c53980	b9c6ce23-7173-41dd-be46-cdfb74fec18a	t
ea8fbaa3-b5f1-4548-acef-7f4622c53980	1ed0d4c4-0720-4e69-be21-091241d3c574	f
ea8fbaa3-b5f1-4548-acef-7f4622c53980	49ab1a06-38f4-4c32-868e-48b61022c00f	f
ea8fbaa3-b5f1-4548-acef-7f4622c53980	411c662c-cd97-4f46-a8bc-7a4f473f7cfb	f
ea8fbaa3-b5f1-4548-acef-7f4622c53980	34aa2dce-16c8-457d-9178-bb836e027ca2	f
ea8fbaa3-b5f1-4548-acef-7f4622c53980	813c8c55-74e0-494f-9682-23d026340f42	f
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	ef14b883-04bf-4557-be1a-231b99162857	t
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	fa609b0e-925f-4251-a437-291fdf9d71a1	t
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	5b0a8700-85e8-46b9-a764-6cd2f85d8846	t
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	178dac49-f258-4a20-a227-baca55f97d8d	t
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	51061315-4b70-49de-b605-55a40d6ab93f	t
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	b9c6ce23-7173-41dd-be46-cdfb74fec18a	t
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	1ed0d4c4-0720-4e69-be21-091241d3c574	f
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	49ab1a06-38f4-4c32-868e-48b61022c00f	f
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	411c662c-cd97-4f46-a8bc-7a4f473f7cfb	f
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	34aa2dce-16c8-457d-9178-bb836e027ca2	f
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	813c8c55-74e0-494f-9682-23d026340f42	f
2aceca6f-245d-4ffe-80a0-efc46198a4f2	ef14b883-04bf-4557-be1a-231b99162857	t
2aceca6f-245d-4ffe-80a0-efc46198a4f2	fa609b0e-925f-4251-a437-291fdf9d71a1	t
2aceca6f-245d-4ffe-80a0-efc46198a4f2	5b0a8700-85e8-46b9-a764-6cd2f85d8846	t
2aceca6f-245d-4ffe-80a0-efc46198a4f2	178dac49-f258-4a20-a227-baca55f97d8d	t
2aceca6f-245d-4ffe-80a0-efc46198a4f2	51061315-4b70-49de-b605-55a40d6ab93f	t
2aceca6f-245d-4ffe-80a0-efc46198a4f2	b9c6ce23-7173-41dd-be46-cdfb74fec18a	t
2aceca6f-245d-4ffe-80a0-efc46198a4f2	1ed0d4c4-0720-4e69-be21-091241d3c574	f
2aceca6f-245d-4ffe-80a0-efc46198a4f2	49ab1a06-38f4-4c32-868e-48b61022c00f	f
2aceca6f-245d-4ffe-80a0-efc46198a4f2	411c662c-cd97-4f46-a8bc-7a4f473f7cfb	f
2aceca6f-245d-4ffe-80a0-efc46198a4f2	34aa2dce-16c8-457d-9178-bb836e027ca2	f
2aceca6f-245d-4ffe-80a0-efc46198a4f2	813c8c55-74e0-494f-9682-23d026340f42	f
b323fd36-7155-40a7-9eb1-94d315656e84	ef14b883-04bf-4557-be1a-231b99162857	t
b323fd36-7155-40a7-9eb1-94d315656e84	fa609b0e-925f-4251-a437-291fdf9d71a1	t
b323fd36-7155-40a7-9eb1-94d315656e84	5b0a8700-85e8-46b9-a764-6cd2f85d8846	t
b323fd36-7155-40a7-9eb1-94d315656e84	178dac49-f258-4a20-a227-baca55f97d8d	t
b323fd36-7155-40a7-9eb1-94d315656e84	51061315-4b70-49de-b605-55a40d6ab93f	t
b323fd36-7155-40a7-9eb1-94d315656e84	b9c6ce23-7173-41dd-be46-cdfb74fec18a	t
b323fd36-7155-40a7-9eb1-94d315656e84	1ed0d4c4-0720-4e69-be21-091241d3c574	f
b323fd36-7155-40a7-9eb1-94d315656e84	49ab1a06-38f4-4c32-868e-48b61022c00f	f
b323fd36-7155-40a7-9eb1-94d315656e84	411c662c-cd97-4f46-a8bc-7a4f473f7cfb	f
b323fd36-7155-40a7-9eb1-94d315656e84	34aa2dce-16c8-457d-9178-bb836e027ca2	f
b323fd36-7155-40a7-9eb1-94d315656e84	813c8c55-74e0-494f-9682-23d026340f42	f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
7fe79f44-d68f-4337-acb6-e000d1159d2a	92113a2d-3b7a-49ad-92f4-ac6a8f8f370f
34aa2dce-16c8-457d-9178-bb836e027ca2	5926e4b6-ce4f-44c7-b71f-3ec7ffb9cdd6
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
0ef7ea4a-7739-42a6-b0c0-27c4294a076c	Trusted Hosts	b438138c-504f-4895-bc39-d44717b59327	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	b438138c-504f-4895-bc39-d44717b59327	anonymous
316a9687-2086-4297-82cb-0bb9c392107a	Consent Required	b438138c-504f-4895-bc39-d44717b59327	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	b438138c-504f-4895-bc39-d44717b59327	anonymous
e98e26d7-54a2-4d58-9941-9a6e2cf0c5df	Full Scope Disabled	b438138c-504f-4895-bc39-d44717b59327	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	b438138c-504f-4895-bc39-d44717b59327	anonymous
ef6daf18-62a8-4323-b806-2ee366afabdb	Max Clients Limit	b438138c-504f-4895-bc39-d44717b59327	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	b438138c-504f-4895-bc39-d44717b59327	anonymous
25cbf41f-b78a-4e62-bfde-096f8cc113b7	Allowed Protocol Mapper Types	b438138c-504f-4895-bc39-d44717b59327	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	b438138c-504f-4895-bc39-d44717b59327	anonymous
37f72333-081a-466f-b445-7216c4ee4335	Allowed Client Scopes	b438138c-504f-4895-bc39-d44717b59327	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	b438138c-504f-4895-bc39-d44717b59327	anonymous
92309a3f-6737-4539-94c8-16ddba9d326e	Allowed Protocol Mapper Types	b438138c-504f-4895-bc39-d44717b59327	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	b438138c-504f-4895-bc39-d44717b59327	authenticated
7066aa46-356e-4093-94d8-1407c61ca346	Allowed Client Scopes	b438138c-504f-4895-bc39-d44717b59327	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	b438138c-504f-4895-bc39-d44717b59327	authenticated
6138f630-c0fc-4f17-8bd2-3f5fc23efbfd	rsa-generated	b438138c-504f-4895-bc39-d44717b59327	rsa-generated	org.keycloak.keys.KeyProvider	b438138c-504f-4895-bc39-d44717b59327	\N
15a117b5-6872-4e4e-ae53-c287d3dcd530	rsa-enc-generated	b438138c-504f-4895-bc39-d44717b59327	rsa-enc-generated	org.keycloak.keys.KeyProvider	b438138c-504f-4895-bc39-d44717b59327	\N
f9c66af5-7b2b-4b6d-bc38-0fb619b52c7b	hmac-generated-hs512	b438138c-504f-4895-bc39-d44717b59327	hmac-generated	org.keycloak.keys.KeyProvider	b438138c-504f-4895-bc39-d44717b59327	\N
4f7f86bc-1fce-472d-8ef9-8ae3eb50736f	aes-generated	b438138c-504f-4895-bc39-d44717b59327	aes-generated	org.keycloak.keys.KeyProvider	b438138c-504f-4895-bc39-d44717b59327	\N
c253bd97-75a9-4476-9475-10840a065588	\N	b438138c-504f-4895-bc39-d44717b59327	declarative-user-profile	org.keycloak.userprofile.UserProfileProvider	b438138c-504f-4895-bc39-d44717b59327	\N
b71bf5a6-37ea-4c32-822f-de4797bb074a	Trusted Hosts	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	anonymous
bf606f65-9004-466b-9d40-a6b50b2bd640	Allowed Client Scopes	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	authenticated
586f8092-e1eb-4f53-adb0-13ae57fd9c9e	Allowed Protocol Mapper Types	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	authenticated
2c981e81-9e87-4554-b03c-6fdbf1694394	Allowed Protocol Mapper Types	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	anonymous
76267d78-0168-4bda-9714-cfe0abd50ab6	Consent Required	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	anonymous
164683a5-7f15-484f-828a-3bdcfcee8f8c	Max Clients Limit	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	anonymous
433d2e7e-ee04-4530-9555-76d4f0ac6c9f	Allowed Client Scopes	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	anonymous
535cae0d-8bf6-4635-98a3-b48d0cb9bff2	Full Scope Disabled	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	anonymous
af488bd5-4ba4-4d10-9f0d-4a4da0e511f1	hmac-generated-hs512	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	hmac-generated	org.keycloak.keys.KeyProvider	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	\N
efed6c49-d4cc-49ec-bb30-6df3ce164dfe	rsa-generated	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	rsa-generated	org.keycloak.keys.KeyProvider	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	\N
5489f72b-e1c1-40ed-8860-68a1892a33ae	aes-generated	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	aes-generated	org.keycloak.keys.KeyProvider	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	\N
71f205f1-9661-4758-91f7-f6ecf7d1631c	rsa-enc-generated	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	rsa-enc-generated	org.keycloak.keys.KeyProvider	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	\N
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
fa34d8f3-4840-4f65-8ad6-86e786c4ce13	25cbf41f-b78a-4e62-bfde-096f8cc113b7	allowed-protocol-mapper-types	saml-user-property-mapper
66f91448-db93-4602-8ff7-8251a6b43705	25cbf41f-b78a-4e62-bfde-096f8cc113b7	allowed-protocol-mapper-types	saml-role-list-mapper
e9bf5ae2-8534-4591-99ee-f0e2d4ba9a24	25cbf41f-b78a-4e62-bfde-096f8cc113b7	allowed-protocol-mapper-types	oidc-full-name-mapper
062dc457-6603-4d3e-965d-703fd5b9069a	25cbf41f-b78a-4e62-bfde-096f8cc113b7	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
8862ffeb-3bd4-424f-8377-41dec3c86fb2	25cbf41f-b78a-4e62-bfde-096f8cc113b7	allowed-protocol-mapper-types	saml-user-attribute-mapper
f2ea88d2-3a0f-4817-a784-bfb865c7db57	25cbf41f-b78a-4e62-bfde-096f8cc113b7	allowed-protocol-mapper-types	oidc-address-mapper
2f9a0193-1fad-4470-b6ed-cca412a7f6fe	25cbf41f-b78a-4e62-bfde-096f8cc113b7	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
e76d1acb-9ac4-4667-9e12-419918fe935b	25cbf41f-b78a-4e62-bfde-096f8cc113b7	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
1ea35306-a001-4fcc-81c3-60127e3df675	7066aa46-356e-4093-94d8-1407c61ca346	allow-default-scopes	true
6a3ed008-62bb-4f86-95fa-bfcd854b5411	92309a3f-6737-4539-94c8-16ddba9d326e	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
c809e2f2-e1e4-4c37-9e30-ffe40db1c275	92309a3f-6737-4539-94c8-16ddba9d326e	allowed-protocol-mapper-types	saml-user-attribute-mapper
29e8ec00-c6c5-4276-bc55-aa6f67aeb904	92309a3f-6737-4539-94c8-16ddba9d326e	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
79547e1b-6fcb-4478-815b-01cc49eaa605	92309a3f-6737-4539-94c8-16ddba9d326e	allowed-protocol-mapper-types	saml-role-list-mapper
51e7cfc3-2364-4d41-9882-06ad6035b70b	92309a3f-6737-4539-94c8-16ddba9d326e	allowed-protocol-mapper-types	saml-user-property-mapper
3402e35a-23f0-48cc-af8e-fe69900575c6	92309a3f-6737-4539-94c8-16ddba9d326e	allowed-protocol-mapper-types	oidc-full-name-mapper
cb0bd5f6-ec6d-4036-a46f-464975e6400a	92309a3f-6737-4539-94c8-16ddba9d326e	allowed-protocol-mapper-types	oidc-address-mapper
31508b08-35df-4190-a94f-f2358ea0f233	92309a3f-6737-4539-94c8-16ddba9d326e	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
946a4e08-b62f-4825-b08c-270ece1b16d0	37f72333-081a-466f-b445-7216c4ee4335	allow-default-scopes	true
095d91f7-5d05-4a7e-b9b8-efa7354a4bfb	0ef7ea4a-7739-42a6-b0c0-27c4294a076c	host-sending-registration-request-must-match	true
68cc24e6-b25f-44a1-bd99-0185d3f14242	0ef7ea4a-7739-42a6-b0c0-27c4294a076c	client-uris-must-match	true
b0e4cfaf-39f3-4395-a31d-8ff80938f3f9	ef6daf18-62a8-4323-b806-2ee366afabdb	max-clients	200
0332b28b-6131-4f35-9e93-9591c24699cf	6138f630-c0fc-4f17-8bd2-3f5fc23efbfd	priority	100
4ed1015d-ee0c-430d-8239-b558a3624b9b	6138f630-c0fc-4f17-8bd2-3f5fc23efbfd	certificate	MIICmzCCAYMCBgGX9OgypTANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjUwNzEwMTUxNDA3WhcNMzUwNzEwMTUxNTQ3WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCYGAEXGaQFtoa7phsLJRrx7q/cmtvcddcMYmyslTpCmHFbfwx/Sd7bZRD0JANpj9EEyzKpAe7/1jGdb1pVkmGsoRJolVy5qUhuxb7N5ZInLTX+qp1HZslh3Tf8z88R9ui0YeZn0/Y1+JrRH1N+DDmWUhxgqwuxXKLTcZQLGIz82c9rew6RKE1232iOUsjVzwxVYifo2uk8/nzWQfJRNwHR7U9e7g9fP/M/Ke3nT+Ou/r8C/HP5C/OinykMP0nTuPdQg7SpDpPP7S8pqK1cgxz2B43CgA55MBZ7Ey4wznjj+fPgvAmLdjJPMlxz0LQE+LBwy3Id48yOS0vMNCnvytYHAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAI1aAQPVJBW/5dRg85ZlF9TWL1eq3z0Zn599IUpNd1gfGLa3bMi2OIZ36z5iydVr/9kzNu468lC7XLe8MMuWUGmx1OLoLVc8aWAE8W5eRGshlFSca0z/WH2mYxSde37hwp87N+ztZPy4JtymtIxDMPGooCeBGz04+4DdoZBv7JOho6eRMQ2H7RSNKbC7jAjABYSiClpuMq6oXi+p0MFU2UojIxRG4ml8zDY2RqV69buhJI0TIcuZyyHqoInZ/oK7j5drnbSL+UMFIMmQ9EgDqS9ZTd0vHSNLbe+ZlTdSfHXPkWhVF2WEVk9EOlWH6UWADbUvb1KN4BsHnSybomCJvdo=
79cd6ef8-a928-469d-95ac-4c6b5dba2e91	6138f630-c0fc-4f17-8bd2-3f5fc23efbfd	keyUse	SIG
1b0f03f9-eeaf-4ced-926d-6db360881c59	6138f630-c0fc-4f17-8bd2-3f5fc23efbfd	privateKey	MIIEowIBAAKCAQEAmBgBFxmkBbaGu6YbCyUa8e6v3Jrb3HXXDGJsrJU6QphxW38Mf0ne22UQ9CQDaY/RBMsyqQHu/9YxnW9aVZJhrKESaJVcualIbsW+zeWSJy01/qqdR2bJYd03/M/PEfbotGHmZ9P2Nfia0R9Tfgw5llIcYKsLsVyi03GUCxiM/NnPa3sOkShNdt9ojlLI1c8MVWIn6NrpPP581kHyUTcB0e1PXu4PXz/zPynt50/jrv6/Avxz+Qvzop8pDD9J07j3UIO0qQ6Tz+0vKaitXIMc9geNwoAOeTAWexMuMM544/nz4LwJi3YyTzJcc9C0BPiwcMtyHePMjktLzDQp78rWBwIDAQABAoIBADTv4e1C4OqWIaYNhgsmgo7jd3VutwiwQUXPuiiFli4YthfVDCn/saAmOLTpFgD3bBZhjUPy5tdIG6PC3qu7E+EMfQZGumvqpknb7PHoLisRmuIFS1HPTleQMkz9nYKQsGUcUCAiT+dwHJ6d6ycLpT2TXcotrpeweQHkXdVQ2b2lnkE5ZBghQgd5QMhw8RfAG3t1qJIlmP8ThvzRIXTsaQo/RSwUMwY7Z58cF8VoX3AHAoJBsm7yI2vZ25oKRhnx4dnuQJyETPaCPacZU8YSp31cOkHkvnaGIhQZlaOAPjtfMYhd0WYQ6IiBrm7N+mY4rgakTU1QrvFK7YZnalp+so0CgYEA1OFIh50IhIEv0BDd7RzO5Uhur0cwTpyw8k/HyjvdDdwQFOX3SCbOuaZknblC1fwFZ9Hzr++mZZKt565hLZLPffyZm3v65JqkXGNnLeJdxdec9GmzhJFaaRvvNXwCfcLP60fwBjB6Rb2yNxp3EDTIihoilJBeDbvmwqJbRL1dW30CgYEAtuazVC5T6eEmhCnIF7IYpNd7y6NmAg3zTAsluq6UQxAx+qNqgfKouVAvKdB76kIg2ETNExsmiMJzZBpKUetFLbXBKY75qhH4JUxY6Q1VxDSLp52M6uyxb/USL6cRINZTOnLFEZqrrHKAITaqsex9yXoDggGcv9w4RlPOAwXZhtMCgYAWHTEDpXR1D1aALsBfGVcEynl1C9gg0nYvNcpzX7Se8/VXtmvxutZOwtJA8DXZNMz68/x0kliexJX8M0k1CsMzO0JZvI9boBTi5BCb26ASJUvQuApGAzN5J8W5sKAxoEMpFdgBTJfnFsWko8Mqk9EhR4XAGR8sHhDityr0ARfpoQKBgQCXlHbGq2ZsDGbJXX8w9C6sXtGAITknNryOJybrokfJlKB3IfvhGmRuwF91/gzURl3GHq7+yJ+U8+KB8a/qWFuK2HjvokiThDTtZGrDKoQMCag8D7x77hHXwXmC+KifWEC9zeQ5BMCGOJar8AxjTKWq1m4VzpREBZS15Dp2EuEGdQKBgBm3VQdxO4RROPggWnOGbg577P0liqYbK++XhjwKHpIkcK4j28EyE/LK7P6WUFbGKA0bPvWW5S1AG/EQpsTr4Y28kTd9P2wX0milIpse+tdrbV0xC6jea+rUXX8ZfgYZAF9r7wVYCbVWGKvGGS9MgJS4eDBI9Od75I0Q8j5Od9gG
af79a3ad-9fa9-410e-893b-1458a59e2e7a	c253bd97-75a9-4476-9475-10840a065588	kc.user.profile.config	{"attributes":[{"name":"username","displayName":"${username}","validations":{"length":{"min":3,"max":255},"username-prohibited-characters":{},"up-username-not-idn-homograph":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"email","displayName":"${email}","validations":{"email":{},"length":{"max":255}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"firstName","displayName":"${firstName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"lastName","displayName":"${lastName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false}],"groups":[{"name":"user-metadata","displayHeader":"User metadata","displayDescription":"Attributes, which refer to user metadata"}]}
6564abae-ad77-41be-a191-d3e9e70e9086	4f7f86bc-1fce-472d-8ef9-8ae3eb50736f	kid	e7ac2cc3-3833-413c-82d5-eec2c408abf8
3b11fce3-c588-45e7-a423-e76788ff15c2	4f7f86bc-1fce-472d-8ef9-8ae3eb50736f	secret	y-2hqZKPBzZP-LiM2Bdn0g
381ab124-8ac8-45d5-a8b4-c0fe2a514174	4f7f86bc-1fce-472d-8ef9-8ae3eb50736f	priority	100
7f836e2e-dca0-4d09-b26b-8471b917a0d7	efed6c49-d4cc-49ec-bb30-6df3ce164dfe	priority	100
ceeb7f08-c63f-4f74-83b6-e991acf55678	15a117b5-6872-4e4e-ae53-c287d3dcd530	privateKey	MIIEowIBAAKCAQEAohHHD82rgEV++7ENa2Qka6LhSyHhTrs669Tnlm1WvPGA3zz3mDenlWxiGjo66vj3eQS7JnWgmZBOGKTOlwAImYRSxUcRoUlRNL3Wo3/ni78yADOwAprLRNnyPXVK+kpbm62VUyI7XiqA1N5a/AiOtTruDWJVJ4GXnqMmKNm8Y/hRFgiXQswq/KnybfexT+GaFez9jPQKnQtV9cfdn7lev45XRbqfSwAdFoQqsEN/Lfth4IuGTjFmZs+2p6XBv2zZouaxt34KNevMZhHNf9FETNxh5piK4M+Kv+5JDe8oUoxO5rxki1WXZULWu+p/qfoQglbYfxpJVmKEbj0aX9hJxQIDAQABAoIBAAIWxZJZaHc3LhmovSvRr+XSmj498tRxPM4Elx0iTjTZI199Pr1MJJFxigWAodyOefU4Mx0d9SDq6xQb57Q5GyphnaJkGYDoTb1DPHrW6Hv0zfxZdVCZgIHHg9JNv+TSGYmfpxfLuRqBj2iLcAysI8lrcKRkvlog825K236OvpJGnKROprIyy/CGGcxLa1hyvw/GiT5N4h+xoMubdUb6isC9CXOaFKcwhXX1z0qI7maqIQAxVQ4GuTEghf6CIIgC77z4+XFdCy7uvwNhrE1Z7FDIkmIxy1YEBTzW8hzzb5PCHS68sKXd6t4bH/iR22Xcu2SwUDz5wOe5IrsLNiliu68CgYEA5HIo4f6uFcOZvVdebpFVLngdXZ3jEGKWmweoW0kf01Dydge/5Nssz67b++J36WXaqKzbBlWsMJE0Kura77pgMSRjn+Mj8txT1MqmBTc2rV1fFVg5htb6SK7s7IcIgiqiH0xMtbpdv1fFrM6Uk6w7y9VQApHtJWEpmF9ViKaEtf8CgYEAtZ4T1UR5KRxckI8zUsd6TR5prHD4+TYrpVvJecEC2sPh6bPXqiQtJbFrj/bcDcfVIK7ZWsVr1rx9UjbSFO/PvDQl1mlxnVNirddR0LHMPZatURsA7H26nPnMqRSZeoHZKk+rhW588zyVRGtb5Ew6yAq+ZKnZcsbkgC61oxYtqDsCgYABKvA4j4O2SsSrahnqeMW1shl8VAVIHSjl6/kZVltaSiyjG9EIS3KEMUGgnPy97a5bdF6+Povdx7A7k+3AkfRR6/yyYYfagvPOv6ZvmmOmKTcGNeg9XzXyTyqY3uvVNoCTpmEyAJzgEIPLKVcrFhNMLG/3Q2Wx7jg3Ni2KwEcnYwKBgQCoNSI1UdfNhaENmjN0pZ/WMSa6OV++oLdHzX0KsQKNzwI7Sv+hayQNVwdCLOaeNMhmHsrcUSCRn72KGY/1KC6EJuAsdzhs97/bNiNmYGXDXPxks9flMIVXwdwVdSi41+5kS6mWSUCcny24Up6nERsYDytLXCwzK5aSSbCcvXvH5QKBgApR2g9/hO+RMTxAAmPDuUZ0lCeCusskKfsz4m57rTDzjTNiZ/qtIyeWk3OPkFflRjl15mpS+oKjrLy9ghHNpgaOGqVf4eo5+u+5PiHfm+DvU1xes5PY1w3PmAzwBRa9grrvWNJzEuPmLLIY7nJtXzMPAVEddfERe/b8y37iYxrh
b087028e-0364-4f54-8ebd-835e1b0cc79e	15a117b5-6872-4e4e-ae53-c287d3dcd530	priority	100
083ca85f-7449-4c35-a3ee-c10476707f5c	15a117b5-6872-4e4e-ae53-c287d3dcd530	keyUse	ENC
2df904d1-b09f-451d-aab8-56dd068453e9	15a117b5-6872-4e4e-ae53-c287d3dcd530	algorithm	RSA-OAEP
f98894da-4e6a-4593-bff7-3a22416b6218	15a117b5-6872-4e4e-ae53-c287d3dcd530	certificate	MIICmzCCAYMCBgGX9OgzLDANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjUwNzEwMTUxNDA3WhcNMzUwNzEwMTUxNTQ3WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCiEccPzauARX77sQ1rZCRrouFLIeFOuzrr1OeWbVa88YDfPPeYN6eVbGIaOjrq+Pd5BLsmdaCZkE4YpM6XAAiZhFLFRxGhSVE0vdajf+eLvzIAM7ACmstE2fI9dUr6SlubrZVTIjteKoDU3lr8CI61Ou4NYlUngZeeoyYo2bxj+FEWCJdCzCr8qfJt97FP4ZoV7P2M9AqdC1X1x92fuV6/jldFup9LAB0WhCqwQ38t+2Hgi4ZOMWZmz7anpcG/bNmi5rG3fgo168xmEc1/0URM3GHmmIrgz4q/7kkN7yhSjE7mvGSLVZdlQta76n+p+hCCVth/GklWYoRuPRpf2EnFAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAFmoga53PJFHKyywqUPakinfhz9JWlW5bAyAKtNRPfuQYi0gI2DkgeQY+fL+pUu/jVmtVG56sJ3R0pVCPHwcnvry/O8busxIuyiB8pwL2KtLqTDRkft9I/x2xaXiXdf9zqg8eAskyJ8jRP5dFyFcrNfTjChDqUycLznaV+Vzs7OxSRXpqQt+W5fPxya606aBpKF7hPzutM6+0q516xsYUYBrWHO3DfJTV6a5H1tf9gSRckcr0sKlQwd/dwIz7PHUAkNo65F0zuf/XZMXAKW+4Zr3rDe0qJhPytsSWm+tKfGynPiRqDtEKzxgjUUmRorGZt1EflBBLjs9h9JYbnZJgms=
da59f316-7bdf-4107-a134-77e8c3314f24	f9c66af5-7b2b-4b6d-bc38-0fb619b52c7b	priority	100
fa9b3005-e765-42a8-98b9-8fb4ca8d459f	f9c66af5-7b2b-4b6d-bc38-0fb619b52c7b	kid	877e4763-236c-46ef-8d92-cf7937c0ccd4
39d550c0-ebdc-4d6f-a141-23ab35776f8b	f9c66af5-7b2b-4b6d-bc38-0fb619b52c7b	algorithm	HS512
21d9bc06-ed5b-45e7-87e0-ef634e885d13	f9c66af5-7b2b-4b6d-bc38-0fb619b52c7b	secret	lwkCTJ28Y67h2KpgxSkO9s_8iiERTO7t0eqK49vuPtu8fP5nIaHlzT3ZoTnvyEOIbA9k6wowY3Ke5-ET5qHWk8lS2_AvJpFEMCDN4wR8Oqlt0Le161MsN8zlF1UvGm6vc-9iXRfyra5eXzeOvWyy3y8sC08EulwartckgUOhkPc
6596da34-e5ed-4949-98e0-78cc29c5661d	b71bf5a6-37ea-4c32-822f-de4797bb074a	client-uris-must-match	true
14c9a694-7fc8-438c-9fec-437a324b210b	b71bf5a6-37ea-4c32-822f-de4797bb074a	host-sending-registration-request-must-match	true
fce13ce7-230e-454c-b751-3a41653d122e	586f8092-e1eb-4f53-adb0-13ae57fd9c9e	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
c86f5129-c491-4838-8029-db38e9bff689	586f8092-e1eb-4f53-adb0-13ae57fd9c9e	allowed-protocol-mapper-types	saml-user-attribute-mapper
2a5149ba-583d-46ee-964c-f6b2e4f41e66	586f8092-e1eb-4f53-adb0-13ae57fd9c9e	allowed-protocol-mapper-types	saml-user-property-mapper
067bc83e-b03b-4fe5-a0a5-9989565a47e7	586f8092-e1eb-4f53-adb0-13ae57fd9c9e	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
63a77fb5-a1b7-4afa-a543-0b5f09062017	586f8092-e1eb-4f53-adb0-13ae57fd9c9e	allowed-protocol-mapper-types	oidc-address-mapper
809e085f-99ac-40fd-92d2-a94c342c5677	586f8092-e1eb-4f53-adb0-13ae57fd9c9e	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
3fde0d0c-9370-448a-acb2-3fd7d1118486	586f8092-e1eb-4f53-adb0-13ae57fd9c9e	allowed-protocol-mapper-types	oidc-full-name-mapper
103c1ebf-2a12-4492-a9a4-a9ef34a6e93a	586f8092-e1eb-4f53-adb0-13ae57fd9c9e	allowed-protocol-mapper-types	saml-role-list-mapper
a86e4710-4b49-47e2-9b45-fda4fe7de3f9	2c981e81-9e87-4554-b03c-6fdbf1694394	allowed-protocol-mapper-types	saml-user-attribute-mapper
3a4d19ca-5341-4154-ad92-32b69a9f5a8d	2c981e81-9e87-4554-b03c-6fdbf1694394	allowed-protocol-mapper-types	oidc-full-name-mapper
a66adeba-7d21-46cb-aa19-06d8698b4f00	2c981e81-9e87-4554-b03c-6fdbf1694394	allowed-protocol-mapper-types	oidc-address-mapper
0d46fe32-45b1-4e16-9945-085250fb9dea	2c981e81-9e87-4554-b03c-6fdbf1694394	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
9668081c-d5fc-4320-b8e4-9738ccd94349	2c981e81-9e87-4554-b03c-6fdbf1694394	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
a900dc11-c09e-474d-b6c3-3016b0225e6e	2c981e81-9e87-4554-b03c-6fdbf1694394	allowed-protocol-mapper-types	saml-role-list-mapper
cbcc88cc-0d7a-4546-925c-3dc038f52807	2c981e81-9e87-4554-b03c-6fdbf1694394	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
6547f816-f701-44e8-87a6-b9adee1e0d50	2c981e81-9e87-4554-b03c-6fdbf1694394	allowed-protocol-mapper-types	saml-user-property-mapper
16cc04b1-bccb-442e-9ea8-62fb1c88ee27	164683a5-7f15-484f-828a-3bdcfcee8f8c	max-clients	200
3a5bed92-3404-478d-aed9-b9791f4bcba4	bf606f65-9004-466b-9d40-a6b50b2bd640	allow-default-scopes	true
19db086d-e013-4304-8f43-a0bf828bf454	5489f72b-e1c1-40ed-8860-68a1892a33ae	priority	100
de38df74-3285-4142-8445-c21ec3075379	5489f72b-e1c1-40ed-8860-68a1892a33ae	secret	AwzswyxW1JTblZGGUmeAtQ
edbd6386-e59c-4de8-8aaf-2d514e46e4a2	5489f72b-e1c1-40ed-8860-68a1892a33ae	kid	9ca1523e-eb2b-4d9e-b522-8c2b5283ff8b
3a57a28f-6df1-440c-b78c-73fd34711caa	433d2e7e-ee04-4530-9555-76d4f0ac6c9f	allow-default-scopes	true
96b0e124-783c-4786-a2c8-b41e99f50b61	af488bd5-4ba4-4d10-9f0d-4a4da0e511f1	kid	23da0bd8-ddfe-4abd-8aab-83fbaf7fa8af
fd8716d2-e3ad-44a2-a8f3-c9b91ee71625	af488bd5-4ba4-4d10-9f0d-4a4da0e511f1	algorithm	HS512
ae7a736d-7300-48c6-9609-ef13ce92c102	af488bd5-4ba4-4d10-9f0d-4a4da0e511f1	priority	100
a3b01e34-a593-4ba5-bcb1-1c60818b771a	af488bd5-4ba4-4d10-9f0d-4a4da0e511f1	secret	ZpmYTgRcipRCEeLcwSIOL5P2p2h_LAIr3B9-ph0ignM4hw_aJRGNz6WYv_xzSMR1DwvL9NsC8NpZqqctU0Y9Vf93K36sFN13rCuwE5_9g-pqt0A7bHn5iGSW4vqZxzEp6BbGuS_8cTyWmEcq4pceh5tQ8-7gk-p_S7igkr9bbxk
2cc194a5-bbf3-4074-a765-a12b0a7b8f76	efed6c49-d4cc-49ec-bb30-6df3ce164dfe	certificate	MIICrzCCAZcCBgGXorkvnDANBgkqhkiG9w0BAQsFADAbMRkwFwYDVQQDDBBuZXh0anMtZGFzaGJvYXJkMB4XDTI1MDYyNDE2MTM1NFoXDTM1MDYyNDE2MTUzNFowGzEZMBcGA1UEAwwQbmV4dGpzLWRhc2hib2FyZDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAN2uY72O52A2dAz3kDvauao1EXQdEVfds7zlWSDc4fx/BEG/lHzZcCb6SWu9hGqksZ/DU8LidrEA3Eb5x9yWJCQkvj0fQPHUsIeSSLfTLNAXmBZS1Tt5ah0a7bauzCJZN4D+TMLZYBW8rxq7B/V3+/+qxHUZ/Ps1LSY5OQD0g/XmTIa4A/TE+8bt6QYV9Pdw8vmEh/hK+SjqONijb5sN/9N8zWIryvZP/jkWvUJAq+3i1AYcKM7pGwmylQtOAdrDUHDnP0BMzJF3A5E9zD7b/r1x6ItrcFJKXOjtp0WdqmZdP6JXqeReDJ0zeXHsWjsoDQwmEqN2tu60VYzvyJQbTgsCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAluDaLZY22PBPhJIVYJKiOw6uIAY3fJ5hTRreN5FcPBwm6C0WH6F1PwK3XzmSzZsI0vynYtAWkoeRKZl5cUX+SywRUhUCA4ChIZ2zizgMpK/789mJBWIulZBO2b/dZj6474clo3UOhuwel/LCTMg6ewJ9JHwwgj/q2DQqcqypWB2kGsSNRiuj6wKsCL5uQiz1IlCA/GhnsfZol5S7EsYa5o4Rs2iHkahmhyMnGoo3eitHtKe+YhaTgwJo7UcEZ4xxdKhKY739F/jpmKLNPFMrGhBr53CS4pgV1CnJbEpYCC4OE1KaZ//IEmg2uagG15MfyQqw9hTCi5FObW8/krtlWg==
5e92956f-c6a3-4850-bfcd-b599d494cdf3	efed6c49-d4cc-49ec-bb30-6df3ce164dfe	keyUse	SIG
b1943bc6-0639-45e4-90b2-f45441c86cd6	efed6c49-d4cc-49ec-bb30-6df3ce164dfe	privateKey	MIIEowIBAAKCAQEA3a5jvY7nYDZ0DPeQO9q5qjURdB0RV92zvOVZINzh/H8EQb+UfNlwJvpJa72EaqSxn8NTwuJ2sQDcRvnH3JYkJCS+PR9A8dSwh5JIt9Ms0BeYFlLVO3lqHRrttq7MIlk3gP5MwtlgFbyvGrsH9Xf7/6rEdRn8+zUtJjk5APSD9eZMhrgD9MT7xu3pBhX093Dy+YSH+Er5KOo42KNvmw3/03zNYivK9k/+ORa9QkCr7eLUBhwozukbCbKVC04B2sNQcOc/QEzMkXcDkT3MPtv+vXHoi2twUkpc6O2nRZ2qZl0/olep5F4MnTN5cexaOygNDCYSo3a27rRVjO/IlBtOCwIDAQABAoIBAAHHK13FEQK65jisHjgbiVtCV9kjER548D8v+ARlGkjpznXc02+QDy/dasLorN5JPpfBYDyuj5mTaUMrCv2LuU8y52NtHPYF38MqCLMidfgyKWR5llHQA0XMWJC/5JbTXe8ZSMR4vkrC6XKg8B15sIfPElOZQoxmHJLOskJHDzZ3LRWCcHr0hLAAgEZwYL+ONwbNcBrtjf+lzKkbtnm9Lo1cJqQ70GqqJ2haXvtPC43W0qjbmEt4jYWxeI/N8CmHnJE7RSkJHYKG/oOtOtnmt04QVKDWq6UJdS3n3naUudU3Uwtf2anpnObwniG0KpZ09WoOMlsWx6rKMKh118tiOZECgYEA76iqj8Ya0K19G8xepGg+8gLNPtUSp0j/0T+17MeqDRUMEn/4sWmLL4Neo3asbplgd5Me74P4b54O8fzPCdPGuY90MJn7eaidCa+uEZ1p+S1Tbs3/uMgveFXdV1tyrQA2bI5ygql9OkKhi8S8m/Ue4PNnJ5h1ThG2slbDnKDmJpsCgYEA7MvqvbRaZq4iXEPwRlRaYvxnUd1tplgZkLnl9McaeYZDpRfl5zAqUQUSjwucB3dSWu9VlDHc8tLJdzrHwpwOY1UpZUKoKmrQof6hCiAbrvrrdA6J2dfW88YA7i/KJinJ4pDMVNAEFPsIy/M+ANTQtKFNNO5p7NjixbeL0S8RNVECgYEAsFCfQu0VF0c7jrL5Qe0rufKTu1EYyxeqlPBRUGTIV52PZyDc/vDOJGN6wbnyO9/9F5uWG9I0eTGIf0FltC4ouqWubn8qgqOo/NJRtsXfjCFri05kfzZPrjFFiRpPMLXCVHUsC7LT3YPdw602sWpRkF+iGYBRdOEVTvkEKnw5NlcCgYAUVqtx4dTF7vz6icdQcxxUVjOVn3w0hmqjuKPcs2E9wN98haH0inmH/fSLHscnCQOk1du239WHcb1mJUFVIMxHkd/9V41UH1qOH227jehyzhB9JmaGtHg89evMiYRGZN53PFKgkkFXf/xQcDMKJT1L1nLoMfYdJr/LlalHrVBAEQKBgGK5Mp0hclAPscutf7KZfYxiACwzTtJTX02ZDt4TRJjVkTonzh2XzrzwPNk67wYEZ0ApTxYumEUrmdUw/Y++sGH5ebq4M1LgjrrDhvWBtpzasVIByE2m+FlL1Fmp16qruMPdkTkx+fqLuzgi4UoQ9Qk2iqCAdy+fKO8pDDbsapnX
b4895364-0117-40f3-88e2-bf2f638fae86	71f205f1-9661-4758-91f7-f6ecf7d1631c	priority	100
1184814a-34ae-4306-bf71-9884ef7a998c	71f205f1-9661-4758-91f7-f6ecf7d1631c	certificate	MIICrzCCAZcCBgGXorkwVDANBgkqhkiG9w0BAQsFADAbMRkwFwYDVQQDDBBuZXh0anMtZGFzaGJvYXJkMB4XDTI1MDYyNDE2MTM1NFoXDTM1MDYyNDE2MTUzNFowGzEZMBcGA1UEAwwQbmV4dGpzLWRhc2hib2FyZDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAK3CpPr0UhFHTCjesYOxFQ9nR+yqp5syeTKVRcZCG3FsfZCdgcx40DD3DyZNu97obDEb1wLu6q0TbdGBVNBpKMk7VuuI3LFc1AWGWc8y4zgY3Tp3cbEPNlDmfUqa4M6g23ogLZMzOsL78PcdCn7aX6WgPWagOWbfxkpsvJKcCci/gwwWYHSmEUydOtqmTFZbsc1sTaIkcHH8BcDawII2RdRyuVIP9lK8fANkC6l5eOk7TXxZDGIoWm+tU5YS8kglswXAamIkHB/NFJWpSg4Nc1DbQPUnEDQyArox7PGjVAgOCleAlj9F7c5yU0msSi/JjgRqtZwATn9u2iLtW7qRMwkCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAcOSW24Vbzq3yZVo1Zh+8/WIFOSbmaz4LmB7jHm7LurnvcvRs3CHjuaGeTsa1WKxwop0HVT7NtbrxQ47pUAm5yB0xmF9vrxNTNCZB50epGXeIfx+OnDA5k1Aak+Yv9/QtB7qY+V5RneEocIAiuvP7xBwb+FcO8W+5zO9C5gVxwGdn/8llDjPiGdEvLAtjKnJmFJUbbrCwmYtLCxAIw8NY3SaDZvTGGRZQwZNcCATplFDvAzhQYk3M/fFfRvF0+2IKWn2EFKE2cJvqEZIgS3bM+Y2LT00Kib+Xh1S6Eta+S055GCCcdU2gSKrvrsBlMQiwYBM/kR/wPtCqa+P5DnQBWQ==
b28a22e2-5aa8-4025-86bf-b799e9cb0fe5	71f205f1-9661-4758-91f7-f6ecf7d1631c	keyUse	ENC
0341b2ee-c719-4ff2-96c6-fd634b3e4ad2	71f205f1-9661-4758-91f7-f6ecf7d1631c	privateKey	MIIEowIBAAKCAQEArcKk+vRSEUdMKN6xg7EVD2dH7KqnmzJ5MpVFxkIbcWx9kJ2BzHjQMPcPJk273uhsMRvXAu7qrRNt0YFU0GkoyTtW64jcsVzUBYZZzzLjOBjdOndxsQ82UOZ9SprgzqDbeiAtkzM6wvvw9x0KftpfpaA9ZqA5Zt/GSmy8kpwJyL+DDBZgdKYRTJ062qZMVluxzWxNoiRwcfwFwNrAgjZF1HK5Ug/2Urx8A2QLqXl46TtNfFkMYihab61TlhLySCWzBcBqYiQcH80UlalKDg1zUNtA9ScQNDICujHs8aNUCA4KV4CWP0XtznJTSaxKL8mOBGq1nABOf27aIu1bupEzCQIDAQABAoIBAAab/O7cxJMKrWTFP7xSITUc88Pr+S8dPDXxLp5sHPjIrH1dOGGLhjkZP1bGJdYZ7M+bZFIkvgFyV+mHAVpiEvPrPBL+eY03ijW27AtGahUpVko8iTMNGz74MsjX26LlxHjAk5Xh9iNni5K4Dzz5rSIIK9MPrM9IcMBGTY/yu9PfwNfywT+3KtXVGbkpbmO5yGsMmEbLwVk9reRE9F31x5JB4dZ9R1JkO45e6vyggI08xBxU46Q3lMfFXWd4i26R4D49AgfyU/I3flYaKDk6+kGjzCmyvDEsbkHBdWIyv2Lv/H4WVATsFZQYTWoG7j73fy9MnLxfufEEmasCl0wgEoECgYEA7QmK/xyVcywbyEpc6xgsOO/KO+63Hnb0po/T2wUIFo7nK9hg7GxRk/Uze/2wa5N+C6tK7HdouxXIevOWV3hzea2l7aACUPuexa3YAVJaRxvZWmQQzCL0y/hYcK3zbnuQfLZSO8fuUylRvEp46UZsVd/FXhsYdm5e/b4k3y0UPikCgYEAu6k1FGCqZbarJx/wsq45c/QjkUrzB9XrRXRpBieRz+YllZ5VbEfrmuMYTkRoUA/J9Jj3iOB5LKO7wB/u5X4brRYLkalLYO8CLayQQyF7zf1xuIsBFn9dwg9lW6SQ1wzE0C9loFLxivubs82UvTFp3pAwD6uUPEnUnxLkWoWCKeECgYAWPILxk7jhaQ3iKDe3Rjk/zh7mqGo9TWN+DJgPP9WWaCl/j3joNPEiNCp0Q0Q9k0SLy7HnpPwKMOzxu9AqvH34uDWMqSoOdsxaNwjAdv1JFm+5bxG0VMMqL038pBTmFGlliaUFPqg43PNx+nqFR7n6BFf7kAcndQssOp4y4YO4oQKBgCQ0jQ0VaUqeZ37w5ptSibsZSxNpBmJony+TOf/5+mPF31JybcCqT4Zecf4HrKhlo20RZhB+XmKCZGK4xnp4ThaivjCoHObiteTh+iM5fo1LbHlSOC+C+y/JkKCRq3ASApa3zj+UQQ2zZWLXMu8dbXOHFf6v97V5+Q+HsY7VWzuBAoGBAIwHoxyJIeu1esxWKGJFdNzptVT9fqFBX8EEodZ1CO3wrTF2flwEspf8075hycN+agENDCbXWJSShIywUM4K8uXWuMGi275fNvOh+N7Cx87GD1KglF0HeXvrpCoZZcCbF/QHSGCYdxicvK8pWhxwXl9oB8HmPPKPTyVEG0PE/MkU
b93ae8b7-3ac0-45ac-bb23-257e6b505436	71f205f1-9661-4758-91f7-f6ecf7d1631c	algorithm	RSA-OAEP
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.composite_role (composite, child_role) FROM stdin;
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	16770a3b-53e3-4d9c-b9e1-79a91b3ab1bc
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	d8c60c9a-eda6-4f92-a17f-ab0732fc9dc9
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	adc21278-0169-4a2e-95df-449ec91ca4af
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	113dd628-f42f-4002-8e40-92aa0e1511c2
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	b788ecd6-35fa-4b11-a8c3-9436b3605bde
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	93a6fe79-a5c5-4809-b497-5d09878fe58a
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	174cad2a-9787-4758-a254-83b50095e225
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	21ccf44f-a57a-4e5c-a920-516c0809ce53
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	3e492a92-ada5-4514-a897-2a82afad4499
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	c78a771d-5e11-4dbf-b9b0-9d3df7a59b6e
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	d38b95fb-e780-4040-80c0-272e934cb048
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	29d787b8-496b-4c7c-bf82-e288d8ef3a85
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	d56cf5e7-ed1b-4069-8dca-2fc06b3d2a8b
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	d016b606-223c-442d-9371-39a4c7415ddb
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	541de763-8808-4e79-8ad8-63839c785591
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	aac77048-b593-49a8-ad4d-b62c9aa040e4
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	57358ace-1a8f-45e0-964c-bf9fc1bf9240
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	cbc2a5b7-6d56-4c2f-8a44-af2091b4b18f
113dd628-f42f-4002-8e40-92aa0e1511c2	cbc2a5b7-6d56-4c2f-8a44-af2091b4b18f
113dd628-f42f-4002-8e40-92aa0e1511c2	541de763-8808-4e79-8ad8-63839c785591
771027ff-f167-418e-9bfc-b15568615f00	66307236-8aa7-4ff2-b24d-213a9311bed6
b788ecd6-35fa-4b11-a8c3-9436b3605bde	aac77048-b593-49a8-ad4d-b62c9aa040e4
771027ff-f167-418e-9bfc-b15568615f00	ebbdf1e0-1173-4921-8973-269edb22361a
ebbdf1e0-1173-4921-8973-269edb22361a	9b3f68bb-0215-431e-829f-85acccfde3f6
73d0998e-4465-4593-a8ac-0e1607d5ede1	b59d7320-dc0f-435c-80d3-ae51bc17ae34
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	b3f235aa-809c-4090-b68e-48b6344cc558
771027ff-f167-418e-9bfc-b15568615f00	92113a2d-3b7a-49ad-92f4-ac6a8f8f370f
771027ff-f167-418e-9bfc-b15568615f00	2e8b2fae-3785-4013-b8d0-35601dceef1e
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	d3f2b46b-1d2f-4e56-9da0-b7b3f02852e6
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	29da2a3a-f737-4a3f-b9d9-40e954e819bc
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	25388024-2a15-41b1-b1f7-ea133fe44044
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	6328552f-acb0-4d43-8ac7-998475e397fd
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	e1c4e945-b83b-4d7a-b82c-dc3190608155
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	daaa92b9-90f7-447e-bc89-f92bd0f042f5
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	36626409-7b98-4f60-9f9a-771398c2ccc7
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	b1dbae63-d73c-45e7-a0a5-1c54de60a77e
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	aa9d2343-ba1f-45b2-8b87-f7e353e06183
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	659f6875-fb94-4d8a-ab40-b285f2045ea4
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	785bdd89-87a2-4942-8b3a-0157f21fec0b
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	f04d5d7c-1456-4c51-b36f-7b5a9e15dbc7
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	0bdc19e2-5dbb-4ccb-86f4-8e92fc53805f
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	a5520c8b-dbc7-489a-ba69-6f8012647d9c
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	40847d31-b1a3-4ddd-85dc-67bd121e733e
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	eeadf727-9693-4d6e-b556-a5ad1678e7ac
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	012ae06e-98de-4484-af3e-b84477e1433c
25388024-2a15-41b1-b1f7-ea133fe44044	012ae06e-98de-4484-af3e-b84477e1433c
25388024-2a15-41b1-b1f7-ea133fe44044	a5520c8b-dbc7-489a-ba69-6f8012647d9c
6328552f-acb0-4d43-8ac7-998475e397fd	40847d31-b1a3-4ddd-85dc-67bd121e733e
039ef22d-8b23-4b53-b9a3-5cc4c045106a	972c32be-9cd3-4007-bae1-55d889a17e95
039ef22d-8b23-4b53-b9a3-5cc4c045106a	e87a45b9-e1ed-414c-97dc-6457c75a7dbe
039ef22d-8b23-4b53-b9a3-5cc4c045106a	15800581-6ec2-42f0-9c41-2f2729999d4f
039ef22d-8b23-4b53-b9a3-5cc4c045106a	60b24f76-8155-4148-8393-6e901d8cbcf9
039ef22d-8b23-4b53-b9a3-5cc4c045106a	a005ca50-933e-4db6-9ea2-347884029741
039ef22d-8b23-4b53-b9a3-5cc4c045106a	99004025-3a53-4034-af27-f6f4f43c9b6c
039ef22d-8b23-4b53-b9a3-5cc4c045106a	2a623913-f224-449c-96be-bde34c5c38df
039ef22d-8b23-4b53-b9a3-5cc4c045106a	d39a71e7-af44-44ab-acbe-a8b775bb7cc0
039ef22d-8b23-4b53-b9a3-5cc4c045106a	3647a876-c772-4463-a922-b8924d0c084d
039ef22d-8b23-4b53-b9a3-5cc4c045106a	8001e5fe-28ba-4edd-8965-aac813d72ac0
039ef22d-8b23-4b53-b9a3-5cc4c045106a	edb6a370-faf8-4585-b4b4-11bf0e3686f6
039ef22d-8b23-4b53-b9a3-5cc4c045106a	8454fee2-3bc4-489b-b5d5-506b198e5d9b
039ef22d-8b23-4b53-b9a3-5cc4c045106a	30aa02d9-cb2b-4296-acb5-cb793f6ce168
039ef22d-8b23-4b53-b9a3-5cc4c045106a	e8d9c21e-8eb4-4d30-a313-db934f7f228a
039ef22d-8b23-4b53-b9a3-5cc4c045106a	1b645b0a-a9e1-4019-857e-29e3b2be12bd
039ef22d-8b23-4b53-b9a3-5cc4c045106a	0f70a87a-27f6-474e-a9db-6e9e31e5c378
039ef22d-8b23-4b53-b9a3-5cc4c045106a	94241f64-7db6-42a3-9a50-203be4be51e7
039ef22d-8b23-4b53-b9a3-5cc4c045106a	f9f8d363-c92f-4507-bdeb-86502debb23e
32d78998-b4a3-4358-9f41-9fb89659de0b	e5ca7bde-db56-490d-afe1-25f4d5636935
32d78998-b4a3-4358-9f41-9fb89659de0b	5926e4b6-ce4f-44c7-b71f-3ec7ffb9cdd6
32d78998-b4a3-4358-9f41-9fb89659de0b	09ddac52-762c-464b-9011-a1cff339f646
32d78998-b4a3-4358-9f41-9fb89659de0b	d42a8b82-d043-4511-b13a-f745401e871d
60b24f76-8155-4148-8393-6e901d8cbcf9	e8d9c21e-8eb4-4d30-a313-db934f7f228a
60b24f76-8155-4148-8393-6e901d8cbcf9	0f70a87a-27f6-474e-a9db-6e9e31e5c378
8001e5fe-28ba-4edd-8965-aac813d72ac0	edb6a370-faf8-4585-b4b4-11bf0e3686f6
e5ca7bde-db56-490d-afe1-25f4d5636935	d61213bf-dbdb-4c2d-a4eb-5a1492f24d62
fafef884-34e4-4dc5-8796-2c56aaa97fe0	2e9319f4-086d-43e7-94a9-022e66ce35e3
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	098c6338-9f0b-4cd8-9001-52d6574ce4b7
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority, version) FROM stdin;
e26679dc-3e09-4b6f-9c62-8a8ea0055fb5	\N	password	999640a9-7a0a-4dd2-ad6b-61ddbab3c82e	1752160548029	\N	{"value":"ZzfkgrcKNkP0EDmPWgYZVS+EJHV2Xg6muUlrScUTXKA=","salt":"S4Wp6LVImvDyZ0XfWHuNFg==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10	0
84918289-b4ba-40a2-b304-bf2531bbeaf5	\N	password	e4d137a8-ca21-4bd5-80dc-69cee3432bdb	1750781734560	\N	{"value":"Q+AR1dGqg788MVCT0ScLB8h+7ZrrEmO/hXLWAuTNogo=","salt":"LOv8Ip0BUCFKnyHb96f4mw==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10	0
8dce8a88-d9d5-4c9c-993a-de27a80b7df0	\N	password	b1c7bfb6-8279-42c6-8cd5-2ac227717fb1	1750959726493	\N	{"value":"fAJUF9so9jzs7YlQIQRWQf+bd7Kk2SL3ppo00X6aaYY=","salt":"dWspPXiLghrBjogEi2aYAQ==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10	0
1163bc89-028f-43e6-a10f-3336d5382c7f	\N	password	ecacf8de-e81a-4ca7-83d6-d7fc200bf9a4	1750781734627	\N	{"value":"Ksj3uKTW2jYojQ/6af3iS0DX0uQAWSojpuCXjYgAv2g=","salt":"6+iHLZjWWYwMkS9DXmq9xg==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10	0
1163bc89-028f-43e6-a10f-4a7607a1e74f	\N	password	ecacf8de-e81a-4ca7-83d6-d7fc202gg9a4	1755781734627	\N	{"value":"Ksj3uKTW2jYojQ/6af3iS0DX0uQAWSojpuCXjYgAv2g=","salt":"6+iHLZjWWYwMkS9DXmq9xg==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10	0
f61ad28f-8d7d-4cc2-a541-4a7607a1e74f	\N	password	15d36145-5cea-49e5-9f9f-fe71bfe502fb	1750781734673	\N	{"value":"Uv/2yUlsCfdtU48X+lblcu0aVD01ev1xLNMniKV/kn4=","salt":"MmEFGvefmgtdM9UJl255sQ==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10	0
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2025-07-10 15:15:32.538394	1	EXECUTED	9:6f1016664e21e16d26517a4418f5e3df	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.29.1	\N	\N	2160531988
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2025-07-10 15:15:32.567747	2	MARK_RAN	9:828775b1596a07d1200ba1d49e5e3941	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.29.1	\N	\N	2160531988
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2025-07-10 15:15:32.626095	3	EXECUTED	9:5f090e44a7d595883c1fb61f4b41fd38	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	4.29.1	\N	\N	2160531988
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2025-07-10 15:15:32.64233	4	EXECUTED	9:c07e577387a3d2c04d1adc9aaad8730e	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	4.29.1	\N	\N	2160531988
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2025-07-10 15:15:32.772923	5	EXECUTED	9:b68ce996c655922dbcd2fe6b6ae72686	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.29.1	\N	\N	2160531988
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2025-07-10 15:15:32.784441	6	MARK_RAN	9:543b5c9989f024fe35c6f6c5a97de88e	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.29.1	\N	\N	2160531988
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2025-07-10 15:15:32.896044	7	EXECUTED	9:765afebbe21cf5bbca048e632df38336	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.29.1	\N	\N	2160531988
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2025-07-10 15:15:32.906455	8	MARK_RAN	9:db4a145ba11a6fdaefb397f6dbf829a1	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.29.1	\N	\N	2160531988
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2025-07-10 15:15:32.920401	9	EXECUTED	9:9d05c7be10cdb873f8bcb41bc3a8ab23	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	4.29.1	\N	\N	2160531988
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2025-07-10 15:15:33.036493	10	EXECUTED	9:18593702353128d53111f9b1ff0b82b8	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	4.29.1	\N	\N	2160531988
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2025-07-10 15:15:33.109468	11	EXECUTED	9:6122efe5f090e41a85c0f1c9e52cbb62	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.29.1	\N	\N	2160531988
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2025-07-10 15:15:33.119142	12	MARK_RAN	9:e1ff28bf7568451453f844c5d54bb0b5	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.29.1	\N	\N	2160531988
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2025-07-10 15:15:33.160002	13	EXECUTED	9:7af32cd8957fbc069f796b61217483fd	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.29.1	\N	\N	2160531988
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-07-10 15:15:33.190544	14	EXECUTED	9:6005e15e84714cd83226bf7879f54190	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	4.29.1	\N	\N	2160531988
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-07-10 15:15:33.194883	15	MARK_RAN	9:bf656f5a2b055d07f314431cae76f06c	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	2160531988
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-07-10 15:15:33.201565	16	MARK_RAN	9:f8dadc9284440469dcf71e25ca6ab99b	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	4.29.1	\N	\N	2160531988
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-07-10 15:15:33.207199	17	EXECUTED	9:d41d8cd98f00b204e9800998ecf8427e	empty		\N	4.29.1	\N	\N	2160531988
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2025-07-10 15:15:33.264921	18	EXECUTED	9:3368ff0be4c2855ee2dd9ca813b38d8e	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	4.29.1	\N	\N	2160531988
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2025-07-10 15:15:33.315341	19	EXECUTED	9:8ac2fb5dd030b24c0570a763ed75ed20	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.29.1	\N	\N	2160531988
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2025-07-10 15:15:33.326418	20	EXECUTED	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.29.1	\N	\N	2160531988
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2025-07-10 15:15:33.333039	21	MARK_RAN	9:831e82914316dc8a57dc09d755f23c51	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.29.1	\N	\N	2160531988
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2025-07-10 15:15:33.339319	22	MARK_RAN	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.29.1	\N	\N	2160531988
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2025-07-10 15:15:33.452209	23	EXECUTED	9:bc3d0f9e823a69dc21e23e94c7a94bb1	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	4.29.1	\N	\N	2160531988
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2025-07-10 15:15:33.46274	24	EXECUTED	9:c9999da42f543575ab790e76439a2679	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.29.1	\N	\N	2160531988
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2025-07-10 15:15:33.466373	25	MARK_RAN	9:0d6c65c6f58732d81569e77b10ba301d	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.29.1	\N	\N	2160531988
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2025-07-10 15:15:34.135205	26	EXECUTED	9:fc576660fc016ae53d2d4778d84d86d0	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	4.29.1	\N	\N	2160531988
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2025-07-10 15:15:34.227172	27	EXECUTED	9:43ed6b0da89ff77206289e87eaa9c024	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	4.29.1	\N	\N	2160531988
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2025-07-10 15:15:34.237902	28	EXECUTED	9:44bae577f551b3738740281eceb4ea70	update tableName=RESOURCE_SERVER_POLICY		\N	4.29.1	\N	\N	2160531988
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2025-07-10 15:15:34.294177	29	EXECUTED	9:bd88e1f833df0420b01e114533aee5e8	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	4.29.1	\N	\N	2160531988
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2025-07-10 15:15:34.31422	30	EXECUTED	9:a7022af5267f019d020edfe316ef4371	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	4.29.1	\N	\N	2160531988
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2025-07-10 15:15:34.342572	31	EXECUTED	9:fc155c394040654d6a79227e56f5e25a	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	4.29.1	\N	\N	2160531988
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2025-07-10 15:15:34.351105	32	EXECUTED	9:eac4ffb2a14795e5dc7b426063e54d88	customChange		\N	4.29.1	\N	\N	2160531988
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-07-10 15:15:34.361056	33	EXECUTED	9:54937c05672568c4c64fc9524c1e9462	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	2160531988
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-07-10 15:15:34.366017	34	MARK_RAN	9:f9753208029f582525ed12011a19d054	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.29.1	\N	\N	2160531988
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-07-10 15:15:34.44528	35	EXECUTED	9:33d72168746f81f98ae3a1e8e0ca3554	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.29.1	\N	\N	2160531988
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2025-07-10 15:15:34.456235	36	EXECUTED	9:61b6d3d7a4c0e0024b0c839da283da0c	addColumn tableName=REALM		\N	4.29.1	\N	\N	2160531988
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-07-10 15:15:34.468089	37	EXECUTED	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	2160531988
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2025-07-10 15:15:34.482164	38	EXECUTED	9:a2b870802540cb3faa72098db5388af3	addColumn tableName=FED_USER_CONSENT		\N	4.29.1	\N	\N	2160531988
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2025-07-10 15:15:34.489199	39	EXECUTED	9:132a67499ba24bcc54fb5cbdcfe7e4c0	addColumn tableName=IDENTITY_PROVIDER		\N	4.29.1	\N	\N	2160531988
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-07-10 15:15:34.493349	40	MARK_RAN	9:938f894c032f5430f2b0fafb1a243462	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	4.29.1	\N	\N	2160531988
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-07-10 15:15:34.497763	41	MARK_RAN	9:845c332ff1874dc5d35974b0babf3006	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	4.29.1	\N	\N	2160531988
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2025-07-10 15:15:34.50914	42	EXECUTED	9:fc86359c079781adc577c5a217e4d04c	customChange		\N	4.29.1	\N	\N	2160531988
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-07-10 15:15:38.694772	43	EXECUTED	9:59a64800e3c0d09b825f8a3b444fa8f4	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	4.29.1	\N	\N	2160531988
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2025-07-10 15:15:38.709958	44	EXECUTED	9:d48d6da5c6ccf667807f633fe489ce88	addColumn tableName=USER_ENTITY		\N	4.29.1	\N	\N	2160531988
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-07-10 15:15:38.721437	45	EXECUTED	9:dde36f7973e80d71fceee683bc5d2951	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	4.29.1	\N	\N	2160531988
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-07-10 15:15:38.73636	46	EXECUTED	9:b855e9b0a406b34fa323235a0cf4f640	customChange		\N	4.29.1	\N	\N	2160531988
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-07-10 15:15:38.743145	47	MARK_RAN	9:51abbacd7b416c50c4421a8cabf7927e	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	4.29.1	\N	\N	2160531988
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-07-10 15:15:39.09151	48	EXECUTED	9:bdc99e567b3398bac83263d375aad143	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	4.29.1	\N	\N	2160531988
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-07-10 15:15:39.10322	49	EXECUTED	9:d198654156881c46bfba39abd7769e69	addColumn tableName=REALM		\N	4.29.1	\N	\N	2160531988
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2025-07-10 15:15:39.147658	50	EXECUTED	9:cfdd8736332ccdd72c5256ccb42335db	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	4.29.1	\N	\N	2160531988
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2025-07-10 15:15:39.884398	51	EXECUTED	9:7c84de3d9bd84d7f077607c1a4dcb714	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	4.29.1	\N	\N	2160531988
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2025-07-10 15:15:39.893577	52	EXECUTED	9:5a6bb36cbefb6a9d6928452c0852af2d	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	2160531988
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2025-07-10 15:15:39.89872	53	EXECUTED	9:8f23e334dbc59f82e0a328373ca6ced0	update tableName=REALM		\N	4.29.1	\N	\N	2160531988
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2025-07-10 15:15:39.904899	54	EXECUTED	9:9156214268f09d970cdf0e1564d866af	update tableName=CLIENT		\N	4.29.1	\N	\N	2160531988
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-07-10 15:15:39.92213	55	EXECUTED	9:db806613b1ed154826c02610b7dbdf74	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	4.29.1	\N	\N	2160531988
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-07-10 15:15:39.932787	56	EXECUTED	9:229a041fb72d5beac76bb94a5fa709de	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	4.29.1	\N	\N	2160531988
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-07-10 15:15:39.992013	57	EXECUTED	9:079899dade9c1e683f26b2aa9ca6ff04	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	4.29.1	\N	\N	2160531988
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-07-10 15:15:40.380835	58	EXECUTED	9:139b79bcbbfe903bb1c2d2a4dbf001d9	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	4.29.1	\N	\N	2160531988
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2025-07-10 15:15:40.407059	59	EXECUTED	9:b55738ad889860c625ba2bf483495a04	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	4.29.1	\N	\N	2160531988
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2025-07-10 15:15:40.41846	60	EXECUTED	9:e0057eac39aa8fc8e09ac6cfa4ae15fe	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	4.29.1	\N	\N	2160531988
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2025-07-10 15:15:40.430403	61	EXECUTED	9:42a33806f3a0443fe0e7feeec821326c	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	4.29.1	\N	\N	2160531988
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2025-07-10 15:15:40.439455	62	EXECUTED	9:9968206fca46eecc1f51db9c024bfe56	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	4.29.1	\N	\N	2160531988
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2025-07-10 15:15:40.446116	63	EXECUTED	9:92143a6daea0a3f3b8f598c97ce55c3d	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	4.29.1	\N	\N	2160531988
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2025-07-10 15:15:40.451175	64	EXECUTED	9:82bab26a27195d889fb0429003b18f40	update tableName=REQUIRED_ACTION_PROVIDER		\N	4.29.1	\N	\N	2160531988
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2025-07-10 15:15:40.456601	65	EXECUTED	9:e590c88ddc0b38b0ae4249bbfcb5abc3	update tableName=RESOURCE_SERVER_RESOURCE		\N	4.29.1	\N	\N	2160531988
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2025-07-10 15:15:40.504994	66	EXECUTED	9:5c1f475536118dbdc38d5d7977950cc0	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	4.29.1	\N	\N	2160531988
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2025-07-10 15:15:40.549572	67	EXECUTED	9:e7c9f5f9c4d67ccbbcc215440c718a17	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	4.29.1	\N	\N	2160531988
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2025-07-10 15:15:40.560013	68	EXECUTED	9:88e0bfdda924690d6f4e430c53447dd5	addColumn tableName=REALM		\N	4.29.1	\N	\N	2160531988
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2025-07-10 15:15:40.617167	69	EXECUTED	9:f53177f137e1c46b6a88c59ec1cb5218	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	4.29.1	\N	\N	2160531988
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2025-07-10 15:15:40.627695	70	EXECUTED	9:a74d33da4dc42a37ec27121580d1459f	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	4.29.1	\N	\N	2160531988
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2025-07-10 15:15:40.634936	71	EXECUTED	9:fd4ade7b90c3b67fae0bfcfcb42dfb5f	addColumn tableName=RESOURCE_SERVER		\N	4.29.1	\N	\N	2160531988
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-07-10 15:15:40.646496	72	EXECUTED	9:aa072ad090bbba210d8f18781b8cebf4	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	4.29.1	\N	\N	2160531988
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-07-10 15:15:40.65892	73	EXECUTED	9:1ae6be29bab7c2aa376f6983b932be37	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.29.1	\N	\N	2160531988
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-07-10 15:15:40.662247	74	MARK_RAN	9:14706f286953fc9a25286dbd8fb30d97	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.29.1	\N	\N	2160531988
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-07-10 15:15:40.685525	75	EXECUTED	9:2b9cc12779be32c5b40e2e67711a218b	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	4.29.1	\N	\N	2160531988
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-07-10 15:15:40.733216	76	EXECUTED	9:91fa186ce7a5af127a2d7a91ee083cc5	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.29.1	\N	\N	2160531988
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-07-10 15:15:40.742014	77	EXECUTED	9:6335e5c94e83a2639ccd68dd24e2e5ad	addColumn tableName=CLIENT		\N	4.29.1	\N	\N	2160531988
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-07-10 15:15:40.745029	78	MARK_RAN	9:6bdb5658951e028bfe16fa0a8228b530	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	4.29.1	\N	\N	2160531988
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-07-10 15:15:40.770108	79	EXECUTED	9:d5bc15a64117ccad481ce8792d4c608f	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	4.29.1	\N	\N	2160531988
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-07-10 15:15:40.774556	80	MARK_RAN	9:077cba51999515f4d3e7ad5619ab592c	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	4.29.1	\N	\N	2160531988
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-07-10 15:15:40.818519	81	EXECUTED	9:be969f08a163bf47c6b9e9ead8ac2afb	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	4.29.1	\N	\N	2160531988
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-07-10 15:15:40.821519	82	MARK_RAN	9:6d3bb4408ba5a72f39bd8a0b301ec6e3	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	2160531988
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-07-10 15:15:40.83284	83	EXECUTED	9:966bda61e46bebf3cc39518fbed52fa7	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	2160531988
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-07-10 15:15:40.835992	84	MARK_RAN	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	2160531988
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-07-10 15:15:40.877986	85	EXECUTED	9:7d93d602352a30c0c317e6a609b56599	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	4.29.1	\N	\N	2160531988
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2025-07-10 15:15:40.888135	86	EXECUTED	9:71c5969e6cdd8d7b6f47cebc86d37627	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	4.29.1	\N	\N	2160531988
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2025-07-10 15:15:40.900272	87	EXECUTED	9:a9ba7d47f065f041b7da856a81762021	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	4.29.1	\N	\N	2160531988
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2025-07-10 15:15:40.909534	88	EXECUTED	9:fffabce2bc01e1a8f5110d5278500065	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	4.29.1	\N	\N	2160531988
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-07-10 15:15:40.919265	89	EXECUTED	9:fa8a5b5445e3857f4b010bafb5009957	addColumn tableName=REALM; customChange		\N	4.29.1	\N	\N	2160531988
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-07-10 15:15:40.928234	90	EXECUTED	9:67ac3241df9a8582d591c5ed87125f39	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	4.29.1	\N	\N	2160531988
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-07-10 15:15:40.968851	91	EXECUTED	9:ad1194d66c937e3ffc82386c050ba089	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	2160531988
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-07-10 15:15:40.980308	92	EXECUTED	9:d9be619d94af5a2f5d07b9f003543b91	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	4.29.1	\N	\N	2160531988
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-07-10 15:15:40.983468	93	MARK_RAN	9:544d201116a0fcc5a5da0925fbbc3bde	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	4.29.1	\N	\N	2160531988
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-07-10 15:15:40.996854	94	EXECUTED	9:43c0c1055b6761b4b3e89de76d612ccf	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	4.29.1	\N	\N	2160531988
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-07-10 15:15:41.000451	95	MARK_RAN	9:8bd711fd0330f4fe980494ca43ab1139	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	4.29.1	\N	\N	2160531988
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-07-10 15:15:41.012746	96	EXECUTED	9:e07d2bc0970c348bb06fb63b1f82ddbf	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	4.29.1	\N	\N	2160531988
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-07-10 15:15:41.121954	97	EXECUTED	9:24fb8611e97f29989bea412aa38d12b7	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	2160531988
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-07-10 15:15:41.125815	98	MARK_RAN	9:259f89014ce2506ee84740cbf7163aa7	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	2160531988
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-07-10 15:15:41.169142	99	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	2160531988
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-07-10 15:15:41.211222	100	EXECUTED	9:60ca84a0f8c94ec8c3504a5a3bc88ee8	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	2160531988
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-07-10 15:15:41.214498	101	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	2160531988
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-07-10 15:15:41.257195	102	EXECUTED	9:0b305d8d1277f3a89a0a53a659ad274c	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	4.29.1	\N	\N	2160531988
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-07-10 15:15:41.264306	103	EXECUTED	9:2c374ad2cdfe20e2905a84c8fac48460	customChange		\N	4.29.1	\N	\N	2160531988
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2025-07-10 15:15:41.274596	104	EXECUTED	9:47a760639ac597360a8219f5b768b4de	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	4.29.1	\N	\N	2160531988
17.0.0-9562	keycloak	META-INF/jpa-changelog-17.0.0.xml	2025-07-10 15:15:41.315386	105	EXECUTED	9:a6272f0576727dd8cad2522335f5d99e	createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY		\N	4.29.1	\N	\N	2160531988
18.0.0-10625-IDX_ADMIN_EVENT_TIME	keycloak	META-INF/jpa-changelog-18.0.0.xml	2025-07-10 15:15:41.352683	106	EXECUTED	9:015479dbd691d9cc8669282f4828c41d	createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY		\N	4.29.1	\N	\N	2160531988
18.0.15-30992-index-consent	keycloak	META-INF/jpa-changelog-18.0.15.xml	2025-07-10 15:15:41.397077	107	EXECUTED	9:80071ede7a05604b1f4906f3bf3b00f0	createIndex indexName=IDX_USCONSENT_SCOPE_ID, tableName=USER_CONSENT_CLIENT_SCOPE		\N	4.29.1	\N	\N	2160531988
19.0.0-10135	keycloak	META-INF/jpa-changelog-19.0.0.xml	2025-07-10 15:15:41.403672	108	EXECUTED	9:9518e495fdd22f78ad6425cc30630221	customChange		\N	4.29.1	\N	\N	2160531988
20.0.0-12964-supported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-07-10 15:15:41.442324	109	EXECUTED	9:e5f243877199fd96bcc842f27a1656ac	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.29.1	\N	\N	2160531988
20.0.0-12964-unsupported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-07-10 15:15:41.445219	110	MARK_RAN	9:1a6fcaa85e20bdeae0a9ce49b41946a5	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.29.1	\N	\N	2160531988
client-attributes-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-07-10 15:15:41.4575	111	EXECUTED	9:3f332e13e90739ed0c35b0b25b7822ca	addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	2160531988
21.0.2-17277	keycloak	META-INF/jpa-changelog-21.0.2.xml	2025-07-10 15:15:41.463687	112	EXECUTED	9:7ee1f7a3fb8f5588f171fb9a6ab623c0	customChange		\N	4.29.1	\N	\N	2160531988
21.1.0-19404	keycloak	META-INF/jpa-changelog-21.1.0.xml	2025-07-10 15:15:41.478421	113	EXECUTED	9:3d7e830b52f33676b9d64f7f2b2ea634	modifyDataType columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=LOGIC, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=POLICY_ENFORCE_MODE, tableName=RESOURCE_SERVER		\N	4.29.1	\N	\N	2160531988
21.1.0-19404-2	keycloak	META-INF/jpa-changelog-21.1.0.xml	2025-07-10 15:15:41.482784	114	MARK_RAN	9:627d032e3ef2c06c0e1f73d2ae25c26c	addColumn tableName=RESOURCE_SERVER_POLICY; update tableName=RESOURCE_SERVER_POLICY; dropColumn columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; renameColumn newColumnName=DECISION_STRATEGY, oldColumnName=DECISION_STRATEGY_NEW, tabl...		\N	4.29.1	\N	\N	2160531988
22.0.0-17484-updated	keycloak	META-INF/jpa-changelog-22.0.0.xml	2025-07-10 15:15:41.489836	115	EXECUTED	9:90af0bfd30cafc17b9f4d6eccd92b8b3	customChange		\N	4.29.1	\N	\N	2160531988
22.0.5-24031	keycloak	META-INF/jpa-changelog-22.0.0.xml	2025-07-10 15:15:41.492753	116	MARK_RAN	9:a60d2d7b315ec2d3eba9e2f145f9df28	customChange		\N	4.29.1	\N	\N	2160531988
23.0.0-12062	keycloak	META-INF/jpa-changelog-23.0.0.xml	2025-07-10 15:15:41.502669	117	EXECUTED	9:2168fbe728fec46ae9baf15bf80927b8	addColumn tableName=COMPONENT_CONFIG; update tableName=COMPONENT_CONFIG; dropColumn columnName=VALUE, tableName=COMPONENT_CONFIG; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=COMPONENT_CONFIG		\N	4.29.1	\N	\N	2160531988
23.0.0-17258	keycloak	META-INF/jpa-changelog-23.0.0.xml	2025-07-10 15:15:41.509266	118	EXECUTED	9:36506d679a83bbfda85a27ea1864dca8	addColumn tableName=EVENT_ENTITY		\N	4.29.1	\N	\N	2160531988
24.0.0-9758	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-07-10 15:15:41.649592	119	EXECUTED	9:502c557a5189f600f0f445a9b49ebbce	addColumn tableName=USER_ATTRIBUTE; addColumn tableName=FED_USER_ATTRIBUTE; createIndex indexName=USER_ATTR_LONG_VALUES, tableName=USER_ATTRIBUTE; createIndex indexName=FED_USER_ATTR_LONG_VALUES, tableName=FED_USER_ATTRIBUTE; createIndex indexName...		\N	4.29.1	\N	\N	2160531988
24.0.0-9758-2	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-07-10 15:15:41.656218	120	EXECUTED	9:bf0fdee10afdf597a987adbf291db7b2	customChange		\N	4.29.1	\N	\N	2160531988
24.0.0-26618-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-07-10 15:15:41.664369	121	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	2160531988
24.0.0-26618-reindex	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-07-10 15:15:41.703659	122	EXECUTED	9:08707c0f0db1cef6b352db03a60edc7f	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	2160531988
24.0.2-27228	keycloak	META-INF/jpa-changelog-24.0.2.xml	2025-07-10 15:15:41.709547	123	EXECUTED	9:eaee11f6b8aa25d2cc6a84fb86fc6238	customChange		\N	4.29.1	\N	\N	2160531988
24.0.2-27967-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.2.xml	2025-07-10 15:15:41.713156	124	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	2160531988
24.0.2-27967-reindex	keycloak	META-INF/jpa-changelog-24.0.2.xml	2025-07-10 15:15:41.717427	125	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	2160531988
25.0.0-28265-tables	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-07-10 15:15:41.724723	126	EXECUTED	9:deda2df035df23388af95bbd36c17cef	addColumn tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_CLIENT_SESSION		\N	4.29.1	\N	\N	2160531988
25.0.0-28265-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-07-10 15:15:41.759576	127	EXECUTED	9:3e96709818458ae49f3c679ae58d263a	createIndex indexName=IDX_OFFLINE_USS_BY_LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	2160531988
25.0.0-28265-index-cleanup-uss-createdon	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-07-10 15:15:42.087705	128	EXECUTED	9:78ab4fc129ed5e8265dbcc3485fba92f	dropIndex indexName=IDX_OFFLINE_USS_CREATEDON, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	2160531988
25.0.0-28265-index-cleanup-uss-preload	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-07-10 15:15:42.271206	129	EXECUTED	9:de5f7c1f7e10994ed8b62e621d20eaab	dropIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	2160531988
25.0.0-28265-index-cleanup-uss-by-usersess	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-07-10 15:15:42.442357	130	EXECUTED	9:6eee220d024e38e89c799417ec33667f	dropIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	2160531988
25.0.0-28265-index-cleanup-css-preload	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-07-10 15:15:42.604427	131	EXECUTED	9:5411d2fb2891d3e8d63ddb55dfa3c0c9	dropIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION		\N	4.29.1	\N	\N	2160531988
25.0.0-28265-index-2-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-07-10 15:15:42.607449	132	MARK_RAN	9:b7ef76036d3126bb83c2423bf4d449d6	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	2160531988
25.0.0-28265-index-2-not-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-07-10 15:15:42.654281	133	EXECUTED	9:23396cf51ab8bc1ae6f0cac7f9f6fcf7	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	2160531988
25.0.0-org	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-07-10 15:15:42.669414	134	EXECUTED	9:5c859965c2c9b9c72136c360649af157	createTable tableName=ORG; addUniqueConstraint constraintName=UK_ORG_NAME, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_GROUP, tableName=ORG; createTable tableName=ORG_DOMAIN		\N	4.29.1	\N	\N	2160531988
unique-consentuser	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-07-10 15:15:42.681751	135	EXECUTED	9:5857626a2ea8767e9a6c66bf3a2cb32f	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.29.1	\N	\N	2160531988
unique-consentuser-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-07-10 15:15:42.685095	136	MARK_RAN	9:b79478aad5adaa1bc428e31563f55e8e	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.29.1	\N	\N	2160531988
25.0.0-28861-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-07-10 15:15:42.765408	137	EXECUTED	9:b9acb58ac958d9ada0fe12a5d4794ab1	createIndex indexName=IDX_PERM_TICKET_REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; createIndex indexName=IDX_PERM_TICKET_OWNER, tableName=RESOURCE_SERVER_PERM_TICKET		\N	4.29.1	\N	\N	2160531988
26.0.0-org-alias	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-07-10 15:15:42.774588	138	EXECUTED	9:6ef7d63e4412b3c2d66ed179159886a4	addColumn tableName=ORG; update tableName=ORG; addNotNullConstraint columnName=ALIAS, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_ALIAS, tableName=ORG		\N	4.29.1	\N	\N	2160531988
26.0.0-org-group	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-07-10 15:15:42.787817	139	EXECUTED	9:da8e8087d80ef2ace4f89d8c5b9ca223	addColumn tableName=KEYCLOAK_GROUP; update tableName=KEYCLOAK_GROUP; addNotNullConstraint columnName=TYPE, tableName=KEYCLOAK_GROUP; customChange		\N	4.29.1	\N	\N	2160531988
26.0.0-org-indexes	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-07-10 15:15:42.831754	140	EXECUTED	9:79b05dcd610a8c7f25ec05135eec0857	createIndex indexName=IDX_ORG_DOMAIN_ORG_ID, tableName=ORG_DOMAIN		\N	4.29.1	\N	\N	2160531988
26.0.0-org-group-membership	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-07-10 15:15:42.84127	141	EXECUTED	9:a6ace2ce583a421d89b01ba2a28dc2d4	addColumn tableName=USER_GROUP_MEMBERSHIP; update tableName=USER_GROUP_MEMBERSHIP; addNotNullConstraint columnName=MEMBERSHIP_TYPE, tableName=USER_GROUP_MEMBERSHIP		\N	4.29.1	\N	\N	2160531988
31296-persist-revoked-access-tokens	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-07-10 15:15:42.851136	142	EXECUTED	9:64ef94489d42a358e8304b0e245f0ed4	createTable tableName=REVOKED_TOKEN; addPrimaryKey constraintName=CONSTRAINT_RT, tableName=REVOKED_TOKEN		\N	4.29.1	\N	\N	2160531988
31725-index-persist-revoked-access-tokens	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-07-10 15:15:42.891151	143	EXECUTED	9:b994246ec2bf7c94da881e1d28782c7b	createIndex indexName=IDX_REV_TOKEN_ON_EXPIRE, tableName=REVOKED_TOKEN		\N	4.29.1	\N	\N	2160531988
26.0.0-idps-for-login	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-07-10 15:15:42.969375	144	EXECUTED	9:51f5fffadf986983d4bd59582c6c1604	addColumn tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_REALM_ORG, tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_FOR_LOGIN, tableName=IDENTITY_PROVIDER; customChange		\N	4.29.1	\N	\N	2160531988
26.0.0-32583-drop-redundant-index-on-client-session	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-07-10 15:15:43.147193	145	EXECUTED	9:24972d83bf27317a055d234187bb4af9	dropIndex indexName=IDX_US_SESS_ID_ON_CL_SESS, tableName=OFFLINE_CLIENT_SESSION		\N	4.29.1	\N	\N	2160531988
26.0.0.32582-remove-tables-user-session-user-session-note-and-client-session	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-07-10 15:15:43.161131	146	EXECUTED	9:febdc0f47f2ed241c59e60f58c3ceea5	dropTable tableName=CLIENT_SESSION_ROLE; dropTable tableName=CLIENT_SESSION_NOTE; dropTable tableName=CLIENT_SESSION_PROT_MAPPER; dropTable tableName=CLIENT_SESSION_AUTH_STATUS; dropTable tableName=CLIENT_USER_SESSION_NOTE; dropTable tableName=CLI...		\N	4.29.1	\N	\N	2160531988
26.0.0-33201-org-redirect-url	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-07-10 15:15:43.167471	147	EXECUTED	9:4d0e22b0ac68ebe9794fa9cb752ea660	addColumn tableName=ORG		\N	4.29.1	\N	\N	2160531988
29399-jdbc-ping-default	keycloak	META-INF/jpa-changelog-26.1.0.xml	2025-07-10 15:15:43.176103	148	EXECUTED	9:007dbe99d7203fca403b89d4edfdf21e	createTable tableName=JGROUPS_PING; addPrimaryKey constraintName=CONSTRAINT_JGROUPS_PING, tableName=JGROUPS_PING		\N	4.29.1	\N	\N	2160531988
26.1.0-34013	keycloak	META-INF/jpa-changelog-26.1.0.xml	2025-07-10 15:15:43.199307	149	EXECUTED	9:e6b686a15759aef99a6d758a5c4c6a26	addColumn tableName=ADMIN_EVENT_ENTITY		\N	4.29.1	\N	\N	2160531988
26.1.0-34380	keycloak	META-INF/jpa-changelog-26.1.0.xml	2025-07-10 15:15:43.208232	150	EXECUTED	9:ac8b9edb7c2b6c17a1c7a11fcf5ccf01	dropTable tableName=USERNAME_LOGIN_FAILURE		\N	4.29.1	\N	\N	2160531988
26.2.0-36750	keycloak	META-INF/jpa-changelog-26.2.0.xml	2025-07-10 15:15:43.217123	151	EXECUTED	9:b49ce951c22f7eb16480ff085640a33a	createTable tableName=SERVER_CONFIG		\N	4.29.1	\N	\N	2160531988
26.2.0-26106	keycloak	META-INF/jpa-changelog-26.2.0.xml	2025-07-10 15:15:43.225133	152	EXECUTED	9:b5877d5dab7d10ff3a9d209d7beb6680	addColumn tableName=CREDENTIAL		\N	4.29.1	\N	\N	2160531988
26.2.6-39866-duplicate	keycloak	META-INF/jpa-changelog-26.2.6.xml	2025-07-10 15:15:43.230688	153	EXECUTED	9:1dc67ccee24f30331db2cba4f372e40e	customChange		\N	4.29.1	\N	\N	2160531988
26.2.6-39866-uk	keycloak	META-INF/jpa-changelog-26.2.6.xml	2025-07-10 15:15:43.236917	154	EXECUTED	9:b70b76f47210cf0a5f4ef0e219eac7cd	addUniqueConstraint constraintName=UK_MIGRATION_VERSION, tableName=MIGRATION_MODEL		\N	4.29.1	\N	\N	2160531988
26.2.6-40088-duplicate	keycloak	META-INF/jpa-changelog-26.2.6.xml	2025-07-10 15:15:43.242457	155	EXECUTED	9:cc7e02ed69ab31979afb1982f9670e8f	customChange		\N	4.29.1	\N	\N	2160531988
26.2.6-40088-uk	keycloak	META-INF/jpa-changelog-26.2.6.xml	2025-07-10 15:15:43.249801	156	EXECUTED	9:5bb848128da7bc4595cc507383325241	addUniqueConstraint constraintName=UK_MIGRATION_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.29.1	\N	\N	2160531988
26.3.0-groups-description	keycloak	META-INF/jpa-changelog-26.3.0.xml	2025-07-10 15:15:43.257314	157	EXECUTED	9:e1a3c05574326fb5b246b73b9a4c4d49	addColumn tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	2160531988
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
b438138c-504f-4895-bc39-d44717b59327	7fe79f44-d68f-4337-acb6-e000d1159d2a	f
b438138c-504f-4895-bc39-d44717b59327	c056cd04-2f6d-40fa-9c2c-3a771cc97cb8	t
b438138c-504f-4895-bc39-d44717b59327	7e71e852-5f73-4c26-81a4-7973ce437597	t
b438138c-504f-4895-bc39-d44717b59327	0430d4e1-e12e-4417-8864-5c6e31e6f4c1	t
b438138c-504f-4895-bc39-d44717b59327	e88b8b0e-70a6-42e8-a740-ab3326601c75	t
b438138c-504f-4895-bc39-d44717b59327	0a3f3395-1539-4523-918a-7bbdd650e256	f
b438138c-504f-4895-bc39-d44717b59327	d90bb3c9-61cd-46d4-9da6-44525a8396e0	f
b438138c-504f-4895-bc39-d44717b59327	59b27656-1314-4e09-b458-98778fccc9d1	t
b438138c-504f-4895-bc39-d44717b59327	b1b2fd01-adbc-4974-8dba-eda2dae12865	t
b438138c-504f-4895-bc39-d44717b59327	25edf6ba-0d33-48ea-9458-585dbf7a0379	f
b438138c-504f-4895-bc39-d44717b59327	454d585d-dd7c-4345-89ff-9dd0ab17d8a4	t
b438138c-504f-4895-bc39-d44717b59327	b7b320a4-771c-4f3c-bf7f-5c1691f791da	t
b438138c-504f-4895-bc39-d44717b59327	557cdfe0-7c65-4218-9de6-25a29f429f55	f
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2977881a-44c7-40ba-aa11-afb0a05ec0b2	t
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	8c468075-525e-4ab3-94ec-ba4dc437c24f	t
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	178dac49-f258-4a20-a227-baca55f97d8d	t
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	b9c6ce23-7173-41dd-be46-cdfb74fec18a	t
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	5b0a8700-85e8-46b9-a764-6cd2f85d8846	t
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	ef14b883-04bf-4557-be1a-231b99162857	t
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	fa609b0e-925f-4251-a437-291fdf9d71a1	t
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	51061315-4b70-49de-b605-55a40d6ab93f	t
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	34aa2dce-16c8-457d-9178-bb836e027ca2	f
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	1ed0d4c4-0720-4e69-be21-091241d3c574	f
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	49ab1a06-38f4-4c32-868e-48b61022c00f	f
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	813c8c55-74e0-494f-9682-23d026340f42	f
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	411c662c-cd97-4f46-a8bc-7a4f473f7cfb	f
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id, details_json_long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only, organization_id, hide_on_login) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: jgroups_ping; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.jgroups_ping (address, name, cluster_name, ip, coord) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.keycloak_group (id, name, parent_group, realm_id, type, description) FROM stdin;
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
771027ff-f167-418e-9bfc-b15568615f00	b438138c-504f-4895-bc39-d44717b59327	f	${role_default-roles}	default-roles-master	b438138c-504f-4895-bc39-d44717b59327	\N	\N
16770a3b-53e3-4d9c-b9e1-79a91b3ab1bc	b438138c-504f-4895-bc39-d44717b59327	f	${role_create-realm}	create-realm	b438138c-504f-4895-bc39-d44717b59327	\N	\N
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	b438138c-504f-4895-bc39-d44717b59327	f	${role_admin}	admin	b438138c-504f-4895-bc39-d44717b59327	\N	\N
d8c60c9a-eda6-4f92-a17f-ab0732fc9dc9	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	t	${role_create-client}	create-client	b438138c-504f-4895-bc39-d44717b59327	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	\N
adc21278-0169-4a2e-95df-449ec91ca4af	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	t	${role_view-realm}	view-realm	b438138c-504f-4895-bc39-d44717b59327	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	\N
113dd628-f42f-4002-8e40-92aa0e1511c2	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	t	${role_view-users}	view-users	b438138c-504f-4895-bc39-d44717b59327	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	\N
b788ecd6-35fa-4b11-a8c3-9436b3605bde	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	t	${role_view-clients}	view-clients	b438138c-504f-4895-bc39-d44717b59327	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	\N
93a6fe79-a5c5-4809-b497-5d09878fe58a	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	t	${role_view-events}	view-events	b438138c-504f-4895-bc39-d44717b59327	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	\N
174cad2a-9787-4758-a254-83b50095e225	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	t	${role_view-identity-providers}	view-identity-providers	b438138c-504f-4895-bc39-d44717b59327	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	\N
21ccf44f-a57a-4e5c-a920-516c0809ce53	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	t	${role_view-authorization}	view-authorization	b438138c-504f-4895-bc39-d44717b59327	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	\N
3e492a92-ada5-4514-a897-2a82afad4499	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	t	${role_manage-realm}	manage-realm	b438138c-504f-4895-bc39-d44717b59327	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	\N
c78a771d-5e11-4dbf-b9b0-9d3df7a59b6e	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	t	${role_manage-users}	manage-users	b438138c-504f-4895-bc39-d44717b59327	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	\N
d38b95fb-e780-4040-80c0-272e934cb048	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	t	${role_manage-clients}	manage-clients	b438138c-504f-4895-bc39-d44717b59327	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	\N
29d787b8-496b-4c7c-bf82-e288d8ef3a85	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	t	${role_manage-events}	manage-events	b438138c-504f-4895-bc39-d44717b59327	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	\N
d56cf5e7-ed1b-4069-8dca-2fc06b3d2a8b	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	t	${role_manage-identity-providers}	manage-identity-providers	b438138c-504f-4895-bc39-d44717b59327	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	\N
d016b606-223c-442d-9371-39a4c7415ddb	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	t	${role_manage-authorization}	manage-authorization	b438138c-504f-4895-bc39-d44717b59327	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	\N
541de763-8808-4e79-8ad8-63839c785591	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	t	${role_query-users}	query-users	b438138c-504f-4895-bc39-d44717b59327	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	\N
aac77048-b593-49a8-ad4d-b62c9aa040e4	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	t	${role_query-clients}	query-clients	b438138c-504f-4895-bc39-d44717b59327	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	\N
57358ace-1a8f-45e0-964c-bf9fc1bf9240	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	t	${role_query-realms}	query-realms	b438138c-504f-4895-bc39-d44717b59327	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	\N
cbc2a5b7-6d56-4c2f-8a44-af2091b4b18f	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	t	${role_query-groups}	query-groups	b438138c-504f-4895-bc39-d44717b59327	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	\N
66307236-8aa7-4ff2-b24d-213a9311bed6	adaa41f0-3a6d-4d36-afff-d00455b42e38	t	${role_view-profile}	view-profile	b438138c-504f-4895-bc39-d44717b59327	adaa41f0-3a6d-4d36-afff-d00455b42e38	\N
ebbdf1e0-1173-4921-8973-269edb22361a	adaa41f0-3a6d-4d36-afff-d00455b42e38	t	${role_manage-account}	manage-account	b438138c-504f-4895-bc39-d44717b59327	adaa41f0-3a6d-4d36-afff-d00455b42e38	\N
9b3f68bb-0215-431e-829f-85acccfde3f6	adaa41f0-3a6d-4d36-afff-d00455b42e38	t	${role_manage-account-links}	manage-account-links	b438138c-504f-4895-bc39-d44717b59327	adaa41f0-3a6d-4d36-afff-d00455b42e38	\N
e0fe516b-0609-4aa0-bcd8-ef4e81b2f7b8	adaa41f0-3a6d-4d36-afff-d00455b42e38	t	${role_view-applications}	view-applications	b438138c-504f-4895-bc39-d44717b59327	adaa41f0-3a6d-4d36-afff-d00455b42e38	\N
b59d7320-dc0f-435c-80d3-ae51bc17ae34	adaa41f0-3a6d-4d36-afff-d00455b42e38	t	${role_view-consent}	view-consent	b438138c-504f-4895-bc39-d44717b59327	adaa41f0-3a6d-4d36-afff-d00455b42e38	\N
73d0998e-4465-4593-a8ac-0e1607d5ede1	adaa41f0-3a6d-4d36-afff-d00455b42e38	t	${role_manage-consent}	manage-consent	b438138c-504f-4895-bc39-d44717b59327	adaa41f0-3a6d-4d36-afff-d00455b42e38	\N
cff0a2de-c74b-4e9f-839a-8fd1486603b7	adaa41f0-3a6d-4d36-afff-d00455b42e38	t	${role_view-groups}	view-groups	b438138c-504f-4895-bc39-d44717b59327	adaa41f0-3a6d-4d36-afff-d00455b42e38	\N
5a425cbe-0d2d-452c-af3d-e2cf21a71348	adaa41f0-3a6d-4d36-afff-d00455b42e38	t	${role_delete-account}	delete-account	b438138c-504f-4895-bc39-d44717b59327	adaa41f0-3a6d-4d36-afff-d00455b42e38	\N
05c8d4f2-f3e3-4aa9-bbef-1e5915453115	84e89c17-22ae-44fb-8383-6b6a552ce599	t	${role_read-token}	read-token	b438138c-504f-4895-bc39-d44717b59327	84e89c17-22ae-44fb-8383-6b6a552ce599	\N
b3f235aa-809c-4090-b68e-48b6344cc558	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	t	${role_impersonation}	impersonation	b438138c-504f-4895-bc39-d44717b59327	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	\N
92113a2d-3b7a-49ad-92f4-ac6a8f8f370f	b438138c-504f-4895-bc39-d44717b59327	f	${role_offline-access}	offline_access	b438138c-504f-4895-bc39-d44717b59327	\N	\N
2e8b2fae-3785-4013-b8d0-35601dceef1e	b438138c-504f-4895-bc39-d44717b59327	f	${role_uma_authorization}	uma_authorization	b438138c-504f-4895-bc39-d44717b59327	\N	\N
32d78998-b4a3-4358-9f41-9fb89659de0b	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	f	${role_default-roles}	default-roles-nextjs-dashboard	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	\N	\N
d3f2b46b-1d2f-4e56-9da0-b7b3f02852e6	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	t	${role_create-client}	create-client	b438138c-504f-4895-bc39-d44717b59327	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	\N
29da2a3a-f737-4a3f-b9d9-40e954e819bc	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	t	${role_view-realm}	view-realm	b438138c-504f-4895-bc39-d44717b59327	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	\N
25388024-2a15-41b1-b1f7-ea133fe44044	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	t	${role_view-users}	view-users	b438138c-504f-4895-bc39-d44717b59327	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	\N
6328552f-acb0-4d43-8ac7-998475e397fd	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	t	${role_view-clients}	view-clients	b438138c-504f-4895-bc39-d44717b59327	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	\N
e1c4e945-b83b-4d7a-b82c-dc3190608155	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	t	${role_view-events}	view-events	b438138c-504f-4895-bc39-d44717b59327	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	\N
daaa92b9-90f7-447e-bc89-f92bd0f042f5	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	t	${role_view-identity-providers}	view-identity-providers	b438138c-504f-4895-bc39-d44717b59327	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	\N
36626409-7b98-4f60-9f9a-771398c2ccc7	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	t	${role_view-authorization}	view-authorization	b438138c-504f-4895-bc39-d44717b59327	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	\N
b1dbae63-d73c-45e7-a0a5-1c54de60a77e	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	t	${role_manage-realm}	manage-realm	b438138c-504f-4895-bc39-d44717b59327	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	\N
aa9d2343-ba1f-45b2-8b87-f7e353e06183	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	t	${role_manage-users}	manage-users	b438138c-504f-4895-bc39-d44717b59327	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	\N
659f6875-fb94-4d8a-ab40-b285f2045ea4	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	t	${role_manage-clients}	manage-clients	b438138c-504f-4895-bc39-d44717b59327	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	\N
785bdd89-87a2-4942-8b3a-0157f21fec0b	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	t	${role_manage-events}	manage-events	b438138c-504f-4895-bc39-d44717b59327	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	\N
f04d5d7c-1456-4c51-b36f-7b5a9e15dbc7	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	t	${role_manage-identity-providers}	manage-identity-providers	b438138c-504f-4895-bc39-d44717b59327	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	\N
0bdc19e2-5dbb-4ccb-86f4-8e92fc53805f	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	t	${role_manage-authorization}	manage-authorization	b438138c-504f-4895-bc39-d44717b59327	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	\N
a5520c8b-dbc7-489a-ba69-6f8012647d9c	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	t	${role_query-users}	query-users	b438138c-504f-4895-bc39-d44717b59327	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	\N
40847d31-b1a3-4ddd-85dc-67bd121e733e	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	t	${role_query-clients}	query-clients	b438138c-504f-4895-bc39-d44717b59327	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	\N
eeadf727-9693-4d6e-b556-a5ad1678e7ac	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	t	${role_query-realms}	query-realms	b438138c-504f-4895-bc39-d44717b59327	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	\N
012ae06e-98de-4484-af3e-b84477e1433c	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	t	${role_query-groups}	query-groups	b438138c-504f-4895-bc39-d44717b59327	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	\N
5926e4b6-ce4f-44c7-b71f-3ec7ffb9cdd6	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	f	${role_offline-access}	offline_access	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	\N	\N
d42a8b82-d043-4511-b13a-f745401e871d	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	f	${role_uma_authorization}	uma_authorization	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	\N	\N
972c32be-9cd3-4007-bae1-55d889a17e95	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_manage-clients}	manage-clients	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
e87a45b9-e1ed-414c-97dc-6457c75a7dbe	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_manage-identity-providers}	manage-identity-providers	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
15800581-6ec2-42f0-9c41-2f2729999d4f	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_manage-users}	manage-users	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
60b24f76-8155-4148-8393-6e901d8cbcf9	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_view-users}	view-users	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
a005ca50-933e-4db6-9ea2-347884029741	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_manage-realm}	manage-realm	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
99004025-3a53-4034-af27-f6f4f43c9b6c	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_view-identity-providers}	view-identity-providers	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
2a623913-f224-449c-96be-bde34c5c38df	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_manage-authorization}	manage-authorization	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
d39a71e7-af44-44ab-acbe-a8b775bb7cc0	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_view-realm}	view-realm	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
3647a876-c772-4463-a922-b8924d0c084d	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_impersonation}	impersonation	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
8001e5fe-28ba-4edd-8965-aac813d72ac0	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_view-clients}	view-clients	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
edb6a370-faf8-4585-b4b4-11bf0e3686f6	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_query-clients}	query-clients	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
8454fee2-3bc4-489b-b5d5-506b198e5d9b	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_create-client}	create-client	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
e8d9c21e-8eb4-4d30-a313-db934f7f228a	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_query-groups}	query-groups	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
039ef22d-8b23-4b53-b9a3-5cc4c045106a	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_realm-admin}	realm-admin	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
30aa02d9-cb2b-4296-acb5-cb793f6ce168	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_view-events}	view-events	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
1b645b0a-a9e1-4019-857e-29e3b2be12bd	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_query-realms}	query-realms	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
0f70a87a-27f6-474e-a9db-6e9e31e5c378	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_query-users}	query-users	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
94241f64-7db6-42a3-9a50-203be4be51e7	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_view-authorization}	view-authorization	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
f9f8d363-c92f-4507-bdeb-86502debb23e	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_manage-events}	manage-events	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
f6f5b69f-434a-4aa7-ba9c-3694c695d9b2	ea8fbaa3-b5f1-4548-acef-7f4622c53980	t	${role_read-token}	read-token	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	ea8fbaa3-b5f1-4548-acef-7f4622c53980	\N
d61213bf-dbdb-4c2d-a4eb-5a1492f24d62	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	t	${role_manage-account-links}	manage-account-links	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	\N
2e9319f4-086d-43e7-94a9-022e66ce35e3	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	t	${role_view-consent}	view-consent	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	\N
e5ca7bde-db56-490d-afe1-25f4d5636935	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	t	${role_manage-account}	manage-account	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	\N
fafef884-34e4-4dc5-8796-2c56aaa97fe0	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	t	${role_manage-consent}	manage-consent	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	\N
c64cd10f-adca-4811-8b5c-87163ed080d7	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	t	${role_delete-account}	delete-account	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	\N
288cb142-db49-44cc-bd8f-cfd2131bd52b	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	t	${role_view-groups}	view-groups	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	\N
09ddac52-762c-464b-9011-a1cff339f646	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	t	${role_view-profile}	view-profile	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	\N
e1f56a64-6997-4035-ac4a-a99a7bdaf927	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	t	${role_view-applications}	view-applications	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	\N
f509302a-4f0d-488f-ac8e-3b2858c5de9f	4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	t	Role for Dashboard Renters in Parkigo client	dashboard_renter	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	\N
38a16972-2598-4dd5-b2de-5a108ce9c748	4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	t	Role for Dashboard Admins in Parkigo client	dashboard_admin	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	\N
1fbe4fc6-50aa-45e4-adbf-f7b73d0e1836	4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	t	Role for Dashboard Owners in Parkigo client	dashboard_owner	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	\N
a0d9da8b-2f4f-4508-a7b2-421220c701ab	4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	t	\N	dashboard_tester	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	\N
098c6338-9f0b-4cd8-9001-52d6574ce4b7	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	t	${role_impersonation}	impersonation	b438138c-504f-4895-bc39-d44717b59327	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	\N
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.migration_model (id, version, update_time) FROM stdin;
cx8yj	26.3.1	1752160545
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id, version) FROM stdin;
c45c9d3a-0aee-4c97-89bf-bb9b746d9fa7	c4162f2d-24d5-4400-99ce-b7bcd4d9b48f	0	1752160836	{"authMethod":"openid-connect","notes":{"clientId":"c4162f2d-24d5-4400-99ce-b7bcd4d9b48f","userSessionStartedAt":"1752160836","iss":"http://localhost:8081/realms/master","startedAt":"1752160836","level-of-authentication":"-1"}}	local	local	0
7c38c59a-7ac4-4c1a-a8ba-2b659b383812	c4162f2d-24d5-4400-99ce-b7bcd4d9b48f	0	1752160837	{"authMethod":"openid-connect","notes":{"clientId":"c4162f2d-24d5-4400-99ce-b7bcd4d9b48f","userSessionStartedAt":"1752160837","iss":"http://localhost:8080/realms/master","startedAt":"1752160837","level-of-authentication":"-1"}}	local	local	0
ef102b9b-2068-4cab-86ee-239af1b7e817	c4162f2d-24d5-4400-99ce-b7bcd4d9b48f	0	1752160944	{"authMethod":"openid-connect","notes":{"clientId":"c4162f2d-24d5-4400-99ce-b7bcd4d9b48f","userSessionStartedAt":"1752160944","iss":"http://localhost:8081/realms/master","startedAt":"1752160944","level-of-authentication":"-1"}}	local	local	0
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh, broker_session_id, version) FROM stdin;
c45c9d3a-0aee-4c97-89bf-bb9b746d9fa7	999640a9-7a0a-4dd2-ad6b-61ddbab3c82e	b438138c-504f-4895-bc39-d44717b59327	1752160836	0	{"ipAddress":"172.18.0.1","authMethod":"openid-connect","rememberMe":false,"started":0,"notes":{"KC_DEVICE_NOTE":"eyJpcEFkZHJlc3MiOiIxNzIuMTguMC4xIiwib3MiOiJPdGhlciIsIm9zVmVyc2lvbiI6IlVua25vd24iLCJicm93c2VyIjoiY3VybC84LjUuMCIsImRldmljZSI6Ik90aGVyIiwibGFzdEFjY2VzcyI6MCwibW9iaWxlIjpmYWxzZX0=","authenticators-completed":"{\\"f228c2eb-c071-43be-b14e-bad0f3fd61e8\\":1752160836,\\"1c56e0f9-3b82-451a-8ba2-d507b602cb1c\\":1752160836}"},"state":"LOGGED_IN"}	1752160836	\N	0
7c38c59a-7ac4-4c1a-a8ba-2b659b383812	999640a9-7a0a-4dd2-ad6b-61ddbab3c82e	b438138c-504f-4895-bc39-d44717b59327	1752160837	0	{"ipAddress":"127.0.0.1","authMethod":"openid-connect","rememberMe":false,"started":0,"notes":{"KC_DEVICE_NOTE":"eyJpcEFkZHJlc3MiOiIxMjcuMC4wLjEiLCJvcyI6Ik90aGVyIiwib3NWZXJzaW9uIjoiVW5rbm93biIsImJyb3dzZXIiOiJBcGFjaGUtSHR0cENsaWVudC80LjUuMTQiLCJkZXZpY2UiOiJPdGhlciIsImxhc3RBY2Nlc3MiOjAsIm1vYmlsZSI6ZmFsc2V9","authenticators-completed":"{\\"f228c2eb-c071-43be-b14e-bad0f3fd61e8\\":1752160837,\\"1c56e0f9-3b82-451a-8ba2-d507b602cb1c\\":1752160837}"},"state":"LOGGED_IN"}	1752160837	\N	0
ef102b9b-2068-4cab-86ee-239af1b7e817	999640a9-7a0a-4dd2-ad6b-61ddbab3c82e	b438138c-504f-4895-bc39-d44717b59327	1752160944	0	{"ipAddress":"172.18.0.1","authMethod":"openid-connect","rememberMe":false,"started":0,"notes":{"KC_DEVICE_NOTE":"eyJpcEFkZHJlc3MiOiIxNzIuMTguMC4xIiwib3MiOiJPdGhlciIsIm9zVmVyc2lvbiI6IlVua25vd24iLCJicm93c2VyIjoiY3VybC84LjUuMCIsImRldmljZSI6Ik90aGVyIiwibGFzdEFjY2VzcyI6MCwibW9iaWxlIjpmYWxzZX0=","authenticators-completed":"{\\"f228c2eb-c071-43be-b14e-bad0f3fd61e8\\":1752160944,\\"1c56e0f9-3b82-451a-8ba2-d507b602cb1c\\":1752160944}"},"state":"LOGGED_IN"}	1752160944	\N	0
\.


--
-- Data for Name: org; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.org (id, enabled, realm_id, group_id, name, description, alias, redirect_url) FROM stdin;
\.


--
-- Data for Name: org_domain; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.org_domain (id, name, verified, org_id) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
2d0a0f8e-b2fb-4ef1-98f5-94fcaa5b5c0f	audience resolve	openid-connect	oidc-audience-resolve-mapper	e549e6ec-8bb9-4897-ae6b-89e65040fc57	\N
3ddfcc84-89a8-43e6-95a9-8bffab2cb055	locale	openid-connect	oidc-usermodel-attribute-mapper	e5a66eb0-ba52-4ce5-9f3a-d7ad118df926	\N
b41439a8-7fc3-4621-8c72-95c389a7b4f2	role list	saml	saml-role-list-mapper	\N	c056cd04-2f6d-40fa-9c2c-3a771cc97cb8
b9481bed-0216-400e-acb3-ac621b8df36e	organization	saml	saml-organization-membership-mapper	\N	7e71e852-5f73-4c26-81a4-7973ce437597
c7dbeef4-7714-4a05-bc52-feaf3eeee9f2	full name	openid-connect	oidc-full-name-mapper	\N	0430d4e1-e12e-4417-8864-5c6e31e6f4c1
2327513e-6b61-4065-982d-e1490c201e0a	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	0430d4e1-e12e-4417-8864-5c6e31e6f4c1
8b0f6d71-8da0-4f93-afe7-71af48cfd0f7	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	0430d4e1-e12e-4417-8864-5c6e31e6f4c1
8ed6b82a-c48d-453f-9d74-402ada23e3e6	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	0430d4e1-e12e-4417-8864-5c6e31e6f4c1
3248a8aa-e248-4042-941a-672f2a261963	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	0430d4e1-e12e-4417-8864-5c6e31e6f4c1
c0084fca-09d1-45e4-9f1d-c3e33e1064ec	username	openid-connect	oidc-usermodel-attribute-mapper	\N	0430d4e1-e12e-4417-8864-5c6e31e6f4c1
8ffa26c0-0b18-453a-b730-7ed9f9544142	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	0430d4e1-e12e-4417-8864-5c6e31e6f4c1
7158c92e-42be-405d-a7c1-46b328d31921	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	0430d4e1-e12e-4417-8864-5c6e31e6f4c1
4d7ab3c7-96d8-498f-a97c-1679cddad447	website	openid-connect	oidc-usermodel-attribute-mapper	\N	0430d4e1-e12e-4417-8864-5c6e31e6f4c1
b91a475b-73e9-4611-b571-0b9229c942c4	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	0430d4e1-e12e-4417-8864-5c6e31e6f4c1
f01c4289-1593-46cf-b568-dd442df15b61	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	0430d4e1-e12e-4417-8864-5c6e31e6f4c1
b101868f-36b0-42fe-9b37-95839ec449cd	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	0430d4e1-e12e-4417-8864-5c6e31e6f4c1
4784d6c1-b0d4-45ba-801f-69dc83c0e7a8	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	0430d4e1-e12e-4417-8864-5c6e31e6f4c1
a878f8f6-de54-4b32-a606-f7b922547038	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	0430d4e1-e12e-4417-8864-5c6e31e6f4c1
17a3e93a-32b2-4e0c-acdf-998af19b0fd3	email	openid-connect	oidc-usermodel-attribute-mapper	\N	e88b8b0e-70a6-42e8-a740-ab3326601c75
b46e1027-5860-42f9-b8fc-600bfaf9aa6b	email verified	openid-connect	oidc-usermodel-property-mapper	\N	e88b8b0e-70a6-42e8-a740-ab3326601c75
b3d47609-9c2c-411f-9fd6-6872e1a41d08	address	openid-connect	oidc-address-mapper	\N	0a3f3395-1539-4523-918a-7bbdd650e256
883cda8a-27ff-4a1f-8158-b2447a6c1c27	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	d90bb3c9-61cd-46d4-9da6-44525a8396e0
1c2c264b-6fce-42c0-88bf-ef14a9aedb2c	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	d90bb3c9-61cd-46d4-9da6-44525a8396e0
b89c2823-ee7b-4fef-b0c8-9942fbaa4970	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	59b27656-1314-4e09-b458-98778fccc9d1
5f207236-9119-4851-b867-328c7bd62090	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	59b27656-1314-4e09-b458-98778fccc9d1
a626cd00-1832-4c9f-894f-28d389afa6b3	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	59b27656-1314-4e09-b458-98778fccc9d1
394a1574-3043-453b-97b5-31595206f747	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	b1b2fd01-adbc-4974-8dba-eda2dae12865
ce5dbbac-7e1b-4c86-bd9f-afac8e8ca448	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	25edf6ba-0d33-48ea-9458-585dbf7a0379
43e5b602-8fba-431b-836b-a716f53c9ae3	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	25edf6ba-0d33-48ea-9458-585dbf7a0379
43505f25-6148-42ab-bb92-5a55831029ce	acr loa level	openid-connect	oidc-acr-mapper	\N	454d585d-dd7c-4345-89ff-9dd0ab17d8a4
0b60a752-fc0e-424f-85f7-e9ec79f63981	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	b7b320a4-771c-4f3c-bf7f-5c1691f791da
fc252338-ffd9-4488-bd08-9fdc9fb205d1	sub	openid-connect	oidc-sub-mapper	\N	b7b320a4-771c-4f3c-bf7f-5c1691f791da
7c34cfff-7773-4150-9e08-04c4efb8b16f	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	\N	44028f5a-5bca-433d-9ff0-79f82cbd3caa
3345a582-cd90-4e8c-8871-9088e5a23d19	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	\N	44028f5a-5bca-433d-9ff0-79f82cbd3caa
5465d25e-9c3d-4f7e-af68-d2c16970a29a	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	\N	44028f5a-5bca-433d-9ff0-79f82cbd3caa
eccca913-2481-4a89-96a3-0df04f36f268	organization	openid-connect	oidc-organization-membership-mapper	\N	557cdfe0-7c65-4218-9de6-25a29f429f55
3e7be768-fbdb-4b2a-8058-8af956a64b1c	acr loa level	openid-connect	oidc-acr-mapper	\N	fa609b0e-925f-4251-a437-291fdf9d71a1
aa5e834b-ecbb-4370-920e-6e357f344b65	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	\N	c6917b9d-3aae-48d7-887d-9d1f1c3c50a0
bf732aa4-eab3-4e40-9a1f-1b9362f5efdb	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	\N	c6917b9d-3aae-48d7-887d-9d1f1c3c50a0
3d5a8744-6de1-4b33-971d-25b65085c6a6	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	\N	c6917b9d-3aae-48d7-887d-9d1f1c3c50a0
7db30151-718b-4e8b-b427-ce7932454cdb	organization	openid-connect	oidc-organization-membership-mapper	\N	411c662c-cd97-4f46-a8bc-7a4f473f7cfb
38a7f9db-01b8-415a-b6bf-70ae1c4eef65	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
7fc105b8-8b25-4cb4-9cd0-214a89fd378a	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
de8ad1a5-2440-4f3d-b34b-a5006cf4ebec	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
35e8889d-ea7a-4b47-8187-04e1262168aa	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
293b68fe-a088-464f-8670-dd211fd22480	full name	openid-connect	oidc-full-name-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
7b8aaffb-fd08-4676-8e3c-9e4831d00fb9	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
395a99cd-b0f0-4cf2-ac8b-eb4807e0292d	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
fcd4f406-7ec0-4438-a9f7-055ecc2530ef	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
fe33b2ef-1731-42cb-a052-6183b0a48317	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
a7773429-78c2-4927-a68c-acf262d05221	username	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
92c4861f-a91b-4498-99d6-975c61de6893	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
d9e2620b-5e17-4bec-b2d9-be8f21b464cb	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
fd5b99a4-55b6-4e26-9db2-f0b921b5de71	website	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
00d212eb-01d5-46b6-b5d5-6508de293795	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
7dd48cb9-01d0-4b51-b52b-1354faf6af82	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	51061315-4b70-49de-b605-55a40d6ab93f
ef392c07-0536-4744-a93a-292f8d4be30f	sub	openid-connect	oidc-sub-mapper	\N	51061315-4b70-49de-b605-55a40d6ab93f
4edd640a-954b-4b4d-8c2a-dc0735636f7b	email verified	openid-connect	oidc-usermodel-property-mapper	\N	b9c6ce23-7173-41dd-be46-cdfb74fec18a
d34a981d-b8e7-468b-857f-d171431008fa	email	openid-connect	oidc-usermodel-attribute-mapper	\N	b9c6ce23-7173-41dd-be46-cdfb74fec18a
1aab1b6e-6475-4f3d-a583-ebab611ccb95	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	5b0a8700-85e8-46b9-a764-6cd2f85d8846
dffa3157-9066-460a-acde-6f76917eaf58	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	5b0a8700-85e8-46b9-a764-6cd2f85d8846
0476f038-5793-43e1-b2f5-ff73109f4acd	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	5b0a8700-85e8-46b9-a764-6cd2f85d8846
5a735885-7e15-446d-9f72-b272e6bb8523	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	ef14b883-04bf-4557-be1a-231b99162857
b2514cf3-1e08-4a6c-874a-93c408c7cda3	address	openid-connect	oidc-address-mapper	\N	1ed0d4c4-0720-4e69-be21-091241d3c574
a32a1db1-71e2-40ed-82f5-47b13bc6de75	role list	saml	saml-role-list-mapper	\N	2977881a-44c7-40ba-aa11-afb0a05ec0b2
e77cb75e-8daa-41e0-94ad-960241c0e49c	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	49ab1a06-38f4-4c32-868e-48b61022c00f
110a70c7-23d4-4057-8b83-2889fa1d7de0	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	49ab1a06-38f4-4c32-868e-48b61022c00f
dc996a1c-997b-41ab-9e5c-3ee8c562e45e	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	813c8c55-74e0-494f-9682-23d026340f42
4584acc2-8518-460a-ac8e-98a0ce64da05	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	813c8c55-74e0-494f-9682-23d026340f42
b7cdfe08-10e3-4826-a086-c3774c59ca61	organization	saml	saml-organization-membership-mapper	\N	8c468075-525e-4ab3-94ec-ba4dc437c24f
34c9adf6-0835-4159-acf6-8517f678a830	audience resolve	openid-connect	oidc-audience-resolve-mapper	6594bd92-c078-437d-aa19-32810411fe71	\N
244b6e81-075f-4cfa-b096-aa4684826425	client roles in id token	openid-connect	oidc-usermodel-client-role-mapper	4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	\N
bfe6ec87-fd46-4d4f-872c-3181f3a96bdd	locale	openid-connect	oidc-usermodel-attribute-mapper	b323fd36-7155-40a7-9eb1-94d315656e84	\N
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
3ddfcc84-89a8-43e6-95a9-8bffab2cb055	true	introspection.token.claim
3ddfcc84-89a8-43e6-95a9-8bffab2cb055	true	userinfo.token.claim
3ddfcc84-89a8-43e6-95a9-8bffab2cb055	locale	user.attribute
3ddfcc84-89a8-43e6-95a9-8bffab2cb055	true	id.token.claim
3ddfcc84-89a8-43e6-95a9-8bffab2cb055	true	access.token.claim
3ddfcc84-89a8-43e6-95a9-8bffab2cb055	locale	claim.name
3ddfcc84-89a8-43e6-95a9-8bffab2cb055	String	jsonType.label
b41439a8-7fc3-4621-8c72-95c389a7b4f2	false	single
b41439a8-7fc3-4621-8c72-95c389a7b4f2	Basic	attribute.nameformat
b41439a8-7fc3-4621-8c72-95c389a7b4f2	Role	attribute.name
2327513e-6b61-4065-982d-e1490c201e0a	true	introspection.token.claim
2327513e-6b61-4065-982d-e1490c201e0a	true	userinfo.token.claim
2327513e-6b61-4065-982d-e1490c201e0a	lastName	user.attribute
2327513e-6b61-4065-982d-e1490c201e0a	true	id.token.claim
2327513e-6b61-4065-982d-e1490c201e0a	true	access.token.claim
2327513e-6b61-4065-982d-e1490c201e0a	family_name	claim.name
2327513e-6b61-4065-982d-e1490c201e0a	String	jsonType.label
3248a8aa-e248-4042-941a-672f2a261963	true	introspection.token.claim
3248a8aa-e248-4042-941a-672f2a261963	true	userinfo.token.claim
3248a8aa-e248-4042-941a-672f2a261963	nickname	user.attribute
3248a8aa-e248-4042-941a-672f2a261963	true	id.token.claim
3248a8aa-e248-4042-941a-672f2a261963	true	access.token.claim
3248a8aa-e248-4042-941a-672f2a261963	nickname	claim.name
3248a8aa-e248-4042-941a-672f2a261963	String	jsonType.label
4784d6c1-b0d4-45ba-801f-69dc83c0e7a8	true	introspection.token.claim
4784d6c1-b0d4-45ba-801f-69dc83c0e7a8	true	userinfo.token.claim
4784d6c1-b0d4-45ba-801f-69dc83c0e7a8	locale	user.attribute
4784d6c1-b0d4-45ba-801f-69dc83c0e7a8	true	id.token.claim
4784d6c1-b0d4-45ba-801f-69dc83c0e7a8	true	access.token.claim
4784d6c1-b0d4-45ba-801f-69dc83c0e7a8	locale	claim.name
4784d6c1-b0d4-45ba-801f-69dc83c0e7a8	String	jsonType.label
4d7ab3c7-96d8-498f-a97c-1679cddad447	true	introspection.token.claim
4d7ab3c7-96d8-498f-a97c-1679cddad447	true	userinfo.token.claim
4d7ab3c7-96d8-498f-a97c-1679cddad447	website	user.attribute
4d7ab3c7-96d8-498f-a97c-1679cddad447	true	id.token.claim
4d7ab3c7-96d8-498f-a97c-1679cddad447	true	access.token.claim
4d7ab3c7-96d8-498f-a97c-1679cddad447	website	claim.name
4d7ab3c7-96d8-498f-a97c-1679cddad447	String	jsonType.label
7158c92e-42be-405d-a7c1-46b328d31921	true	introspection.token.claim
7158c92e-42be-405d-a7c1-46b328d31921	true	userinfo.token.claim
7158c92e-42be-405d-a7c1-46b328d31921	picture	user.attribute
7158c92e-42be-405d-a7c1-46b328d31921	true	id.token.claim
7158c92e-42be-405d-a7c1-46b328d31921	true	access.token.claim
7158c92e-42be-405d-a7c1-46b328d31921	picture	claim.name
7158c92e-42be-405d-a7c1-46b328d31921	String	jsonType.label
8b0f6d71-8da0-4f93-afe7-71af48cfd0f7	true	introspection.token.claim
8b0f6d71-8da0-4f93-afe7-71af48cfd0f7	true	userinfo.token.claim
8b0f6d71-8da0-4f93-afe7-71af48cfd0f7	firstName	user.attribute
8b0f6d71-8da0-4f93-afe7-71af48cfd0f7	true	id.token.claim
8b0f6d71-8da0-4f93-afe7-71af48cfd0f7	true	access.token.claim
8b0f6d71-8da0-4f93-afe7-71af48cfd0f7	given_name	claim.name
8b0f6d71-8da0-4f93-afe7-71af48cfd0f7	String	jsonType.label
8ed6b82a-c48d-453f-9d74-402ada23e3e6	true	introspection.token.claim
8ed6b82a-c48d-453f-9d74-402ada23e3e6	true	userinfo.token.claim
8ed6b82a-c48d-453f-9d74-402ada23e3e6	middleName	user.attribute
8ed6b82a-c48d-453f-9d74-402ada23e3e6	true	id.token.claim
8ed6b82a-c48d-453f-9d74-402ada23e3e6	true	access.token.claim
8ed6b82a-c48d-453f-9d74-402ada23e3e6	middle_name	claim.name
8ed6b82a-c48d-453f-9d74-402ada23e3e6	String	jsonType.label
8ffa26c0-0b18-453a-b730-7ed9f9544142	true	introspection.token.claim
8ffa26c0-0b18-453a-b730-7ed9f9544142	true	userinfo.token.claim
8ffa26c0-0b18-453a-b730-7ed9f9544142	profile	user.attribute
8ffa26c0-0b18-453a-b730-7ed9f9544142	true	id.token.claim
8ffa26c0-0b18-453a-b730-7ed9f9544142	true	access.token.claim
8ffa26c0-0b18-453a-b730-7ed9f9544142	profile	claim.name
8ffa26c0-0b18-453a-b730-7ed9f9544142	String	jsonType.label
a878f8f6-de54-4b32-a606-f7b922547038	true	introspection.token.claim
a878f8f6-de54-4b32-a606-f7b922547038	true	userinfo.token.claim
a878f8f6-de54-4b32-a606-f7b922547038	updatedAt	user.attribute
a878f8f6-de54-4b32-a606-f7b922547038	true	id.token.claim
a878f8f6-de54-4b32-a606-f7b922547038	true	access.token.claim
a878f8f6-de54-4b32-a606-f7b922547038	updated_at	claim.name
a878f8f6-de54-4b32-a606-f7b922547038	long	jsonType.label
b101868f-36b0-42fe-9b37-95839ec449cd	true	introspection.token.claim
b101868f-36b0-42fe-9b37-95839ec449cd	true	userinfo.token.claim
b101868f-36b0-42fe-9b37-95839ec449cd	zoneinfo	user.attribute
b101868f-36b0-42fe-9b37-95839ec449cd	true	id.token.claim
b101868f-36b0-42fe-9b37-95839ec449cd	true	access.token.claim
b101868f-36b0-42fe-9b37-95839ec449cd	zoneinfo	claim.name
b101868f-36b0-42fe-9b37-95839ec449cd	String	jsonType.label
b91a475b-73e9-4611-b571-0b9229c942c4	true	introspection.token.claim
b91a475b-73e9-4611-b571-0b9229c942c4	true	userinfo.token.claim
b91a475b-73e9-4611-b571-0b9229c942c4	gender	user.attribute
b91a475b-73e9-4611-b571-0b9229c942c4	true	id.token.claim
b91a475b-73e9-4611-b571-0b9229c942c4	true	access.token.claim
b91a475b-73e9-4611-b571-0b9229c942c4	gender	claim.name
b91a475b-73e9-4611-b571-0b9229c942c4	String	jsonType.label
c0084fca-09d1-45e4-9f1d-c3e33e1064ec	true	introspection.token.claim
c0084fca-09d1-45e4-9f1d-c3e33e1064ec	true	userinfo.token.claim
c0084fca-09d1-45e4-9f1d-c3e33e1064ec	username	user.attribute
c0084fca-09d1-45e4-9f1d-c3e33e1064ec	true	id.token.claim
c0084fca-09d1-45e4-9f1d-c3e33e1064ec	true	access.token.claim
c0084fca-09d1-45e4-9f1d-c3e33e1064ec	preferred_username	claim.name
c0084fca-09d1-45e4-9f1d-c3e33e1064ec	String	jsonType.label
c7dbeef4-7714-4a05-bc52-feaf3eeee9f2	true	introspection.token.claim
c7dbeef4-7714-4a05-bc52-feaf3eeee9f2	true	userinfo.token.claim
c7dbeef4-7714-4a05-bc52-feaf3eeee9f2	true	id.token.claim
c7dbeef4-7714-4a05-bc52-feaf3eeee9f2	true	access.token.claim
f01c4289-1593-46cf-b568-dd442df15b61	true	introspection.token.claim
f01c4289-1593-46cf-b568-dd442df15b61	true	userinfo.token.claim
f01c4289-1593-46cf-b568-dd442df15b61	birthdate	user.attribute
f01c4289-1593-46cf-b568-dd442df15b61	true	id.token.claim
f01c4289-1593-46cf-b568-dd442df15b61	true	access.token.claim
f01c4289-1593-46cf-b568-dd442df15b61	birthdate	claim.name
f01c4289-1593-46cf-b568-dd442df15b61	String	jsonType.label
17a3e93a-32b2-4e0c-acdf-998af19b0fd3	true	introspection.token.claim
17a3e93a-32b2-4e0c-acdf-998af19b0fd3	true	userinfo.token.claim
17a3e93a-32b2-4e0c-acdf-998af19b0fd3	email	user.attribute
17a3e93a-32b2-4e0c-acdf-998af19b0fd3	true	id.token.claim
17a3e93a-32b2-4e0c-acdf-998af19b0fd3	true	access.token.claim
17a3e93a-32b2-4e0c-acdf-998af19b0fd3	email	claim.name
17a3e93a-32b2-4e0c-acdf-998af19b0fd3	String	jsonType.label
b46e1027-5860-42f9-b8fc-600bfaf9aa6b	true	introspection.token.claim
b46e1027-5860-42f9-b8fc-600bfaf9aa6b	true	userinfo.token.claim
b46e1027-5860-42f9-b8fc-600bfaf9aa6b	emailVerified	user.attribute
b46e1027-5860-42f9-b8fc-600bfaf9aa6b	true	id.token.claim
b46e1027-5860-42f9-b8fc-600bfaf9aa6b	true	access.token.claim
b46e1027-5860-42f9-b8fc-600bfaf9aa6b	email_verified	claim.name
b46e1027-5860-42f9-b8fc-600bfaf9aa6b	boolean	jsonType.label
b3d47609-9c2c-411f-9fd6-6872e1a41d08	formatted	user.attribute.formatted
b3d47609-9c2c-411f-9fd6-6872e1a41d08	country	user.attribute.country
b3d47609-9c2c-411f-9fd6-6872e1a41d08	true	introspection.token.claim
b3d47609-9c2c-411f-9fd6-6872e1a41d08	postal_code	user.attribute.postal_code
b3d47609-9c2c-411f-9fd6-6872e1a41d08	true	userinfo.token.claim
b3d47609-9c2c-411f-9fd6-6872e1a41d08	street	user.attribute.street
b3d47609-9c2c-411f-9fd6-6872e1a41d08	true	id.token.claim
b3d47609-9c2c-411f-9fd6-6872e1a41d08	region	user.attribute.region
b3d47609-9c2c-411f-9fd6-6872e1a41d08	true	access.token.claim
b3d47609-9c2c-411f-9fd6-6872e1a41d08	locality	user.attribute.locality
1c2c264b-6fce-42c0-88bf-ef14a9aedb2c	true	introspection.token.claim
1c2c264b-6fce-42c0-88bf-ef14a9aedb2c	true	userinfo.token.claim
1c2c264b-6fce-42c0-88bf-ef14a9aedb2c	phoneNumberVerified	user.attribute
1c2c264b-6fce-42c0-88bf-ef14a9aedb2c	true	id.token.claim
1c2c264b-6fce-42c0-88bf-ef14a9aedb2c	true	access.token.claim
1c2c264b-6fce-42c0-88bf-ef14a9aedb2c	phone_number_verified	claim.name
1c2c264b-6fce-42c0-88bf-ef14a9aedb2c	boolean	jsonType.label
883cda8a-27ff-4a1f-8158-b2447a6c1c27	true	introspection.token.claim
883cda8a-27ff-4a1f-8158-b2447a6c1c27	true	userinfo.token.claim
883cda8a-27ff-4a1f-8158-b2447a6c1c27	phoneNumber	user.attribute
883cda8a-27ff-4a1f-8158-b2447a6c1c27	true	id.token.claim
883cda8a-27ff-4a1f-8158-b2447a6c1c27	true	access.token.claim
883cda8a-27ff-4a1f-8158-b2447a6c1c27	phone_number	claim.name
883cda8a-27ff-4a1f-8158-b2447a6c1c27	String	jsonType.label
5f207236-9119-4851-b867-328c7bd62090	true	introspection.token.claim
5f207236-9119-4851-b867-328c7bd62090	true	multivalued
5f207236-9119-4851-b867-328c7bd62090	foo	user.attribute
5f207236-9119-4851-b867-328c7bd62090	true	access.token.claim
5f207236-9119-4851-b867-328c7bd62090	resource_access.${client_id}.roles	claim.name
5f207236-9119-4851-b867-328c7bd62090	String	jsonType.label
a626cd00-1832-4c9f-894f-28d389afa6b3	true	introspection.token.claim
a626cd00-1832-4c9f-894f-28d389afa6b3	true	access.token.claim
b89c2823-ee7b-4fef-b0c8-9942fbaa4970	true	introspection.token.claim
b89c2823-ee7b-4fef-b0c8-9942fbaa4970	true	multivalued
b89c2823-ee7b-4fef-b0c8-9942fbaa4970	foo	user.attribute
b89c2823-ee7b-4fef-b0c8-9942fbaa4970	true	access.token.claim
b89c2823-ee7b-4fef-b0c8-9942fbaa4970	realm_access.roles	claim.name
b89c2823-ee7b-4fef-b0c8-9942fbaa4970	String	jsonType.label
394a1574-3043-453b-97b5-31595206f747	true	introspection.token.claim
394a1574-3043-453b-97b5-31595206f747	true	access.token.claim
43e5b602-8fba-431b-836b-a716f53c9ae3	true	introspection.token.claim
43e5b602-8fba-431b-836b-a716f53c9ae3	true	multivalued
43e5b602-8fba-431b-836b-a716f53c9ae3	foo	user.attribute
43e5b602-8fba-431b-836b-a716f53c9ae3	true	id.token.claim
43e5b602-8fba-431b-836b-a716f53c9ae3	true	access.token.claim
43e5b602-8fba-431b-836b-a716f53c9ae3	groups	claim.name
43e5b602-8fba-431b-836b-a716f53c9ae3	String	jsonType.label
ce5dbbac-7e1b-4c86-bd9f-afac8e8ca448	true	introspection.token.claim
ce5dbbac-7e1b-4c86-bd9f-afac8e8ca448	true	userinfo.token.claim
ce5dbbac-7e1b-4c86-bd9f-afac8e8ca448	username	user.attribute
ce5dbbac-7e1b-4c86-bd9f-afac8e8ca448	true	id.token.claim
ce5dbbac-7e1b-4c86-bd9f-afac8e8ca448	true	access.token.claim
ce5dbbac-7e1b-4c86-bd9f-afac8e8ca448	upn	claim.name
ce5dbbac-7e1b-4c86-bd9f-afac8e8ca448	String	jsonType.label
43505f25-6148-42ab-bb92-5a55831029ce	true	introspection.token.claim
43505f25-6148-42ab-bb92-5a55831029ce	true	id.token.claim
43505f25-6148-42ab-bb92-5a55831029ce	true	access.token.claim
0b60a752-fc0e-424f-85f7-e9ec79f63981	AUTH_TIME	user.session.note
0b60a752-fc0e-424f-85f7-e9ec79f63981	true	introspection.token.claim
0b60a752-fc0e-424f-85f7-e9ec79f63981	true	id.token.claim
0b60a752-fc0e-424f-85f7-e9ec79f63981	true	access.token.claim
0b60a752-fc0e-424f-85f7-e9ec79f63981	auth_time	claim.name
0b60a752-fc0e-424f-85f7-e9ec79f63981	long	jsonType.label
fc252338-ffd9-4488-bd08-9fdc9fb205d1	true	introspection.token.claim
fc252338-ffd9-4488-bd08-9fdc9fb205d1	true	access.token.claim
3345a582-cd90-4e8c-8871-9088e5a23d19	clientHost	user.session.note
3345a582-cd90-4e8c-8871-9088e5a23d19	true	introspection.token.claim
3345a582-cd90-4e8c-8871-9088e5a23d19	true	id.token.claim
3345a582-cd90-4e8c-8871-9088e5a23d19	true	access.token.claim
3345a582-cd90-4e8c-8871-9088e5a23d19	clientHost	claim.name
3345a582-cd90-4e8c-8871-9088e5a23d19	String	jsonType.label
5465d25e-9c3d-4f7e-af68-d2c16970a29a	clientAddress	user.session.note
5465d25e-9c3d-4f7e-af68-d2c16970a29a	true	introspection.token.claim
5465d25e-9c3d-4f7e-af68-d2c16970a29a	true	id.token.claim
5465d25e-9c3d-4f7e-af68-d2c16970a29a	true	access.token.claim
5465d25e-9c3d-4f7e-af68-d2c16970a29a	clientAddress	claim.name
5465d25e-9c3d-4f7e-af68-d2c16970a29a	String	jsonType.label
7c34cfff-7773-4150-9e08-04c4efb8b16f	client_id	user.session.note
7c34cfff-7773-4150-9e08-04c4efb8b16f	true	introspection.token.claim
7c34cfff-7773-4150-9e08-04c4efb8b16f	true	id.token.claim
7c34cfff-7773-4150-9e08-04c4efb8b16f	true	access.token.claim
7c34cfff-7773-4150-9e08-04c4efb8b16f	client_id	claim.name
7c34cfff-7773-4150-9e08-04c4efb8b16f	String	jsonType.label
eccca913-2481-4a89-96a3-0df04f36f268	true	introspection.token.claim
eccca913-2481-4a89-96a3-0df04f36f268	true	multivalued
eccca913-2481-4a89-96a3-0df04f36f268	true	id.token.claim
eccca913-2481-4a89-96a3-0df04f36f268	true	access.token.claim
eccca913-2481-4a89-96a3-0df04f36f268	organization	claim.name
eccca913-2481-4a89-96a3-0df04f36f268	String	jsonType.label
3e7be768-fbdb-4b2a-8058-8af956a64b1c	true	id.token.claim
3e7be768-fbdb-4b2a-8058-8af956a64b1c	true	introspection.token.claim
3e7be768-fbdb-4b2a-8058-8af956a64b1c	true	access.token.claim
3e7be768-fbdb-4b2a-8058-8af956a64b1c	true	userinfo.token.claim
3d5a8744-6de1-4b33-971d-25b65085c6a6	clientHost	user.session.note
3d5a8744-6de1-4b33-971d-25b65085c6a6	true	id.token.claim
3d5a8744-6de1-4b33-971d-25b65085c6a6	true	introspection.token.claim
3d5a8744-6de1-4b33-971d-25b65085c6a6	true	access.token.claim
3d5a8744-6de1-4b33-971d-25b65085c6a6	clientHost	claim.name
3d5a8744-6de1-4b33-971d-25b65085c6a6	String	jsonType.label
aa5e834b-ecbb-4370-920e-6e357f344b65	clientAddress	user.session.note
aa5e834b-ecbb-4370-920e-6e357f344b65	true	introspection.token.claim
aa5e834b-ecbb-4370-920e-6e357f344b65	true	userinfo.token.claim
aa5e834b-ecbb-4370-920e-6e357f344b65	true	id.token.claim
aa5e834b-ecbb-4370-920e-6e357f344b65	true	access.token.claim
aa5e834b-ecbb-4370-920e-6e357f344b65	clientAddress	claim.name
aa5e834b-ecbb-4370-920e-6e357f344b65	String	jsonType.label
bf732aa4-eab3-4e40-9a1f-1b9362f5efdb	client_id	user.session.note
bf732aa4-eab3-4e40-9a1f-1b9362f5efdb	true	id.token.claim
bf732aa4-eab3-4e40-9a1f-1b9362f5efdb	true	introspection.token.claim
bf732aa4-eab3-4e40-9a1f-1b9362f5efdb	true	access.token.claim
bf732aa4-eab3-4e40-9a1f-1b9362f5efdb	client_id	claim.name
bf732aa4-eab3-4e40-9a1f-1b9362f5efdb	String	jsonType.label
bf732aa4-eab3-4e40-9a1f-1b9362f5efdb	true	userinfo.token.claim
3d5a8744-6de1-4b33-971d-25b65085c6a6	true	userinfo.token.claim
7db30151-718b-4e8b-b427-ce7932454cdb	true	introspection.token.claim
7db30151-718b-4e8b-b427-ce7932454cdb	true	multivalued
7db30151-718b-4e8b-b427-ce7932454cdb	true	userinfo.token.claim
7db30151-718b-4e8b-b427-ce7932454cdb	true	id.token.claim
7db30151-718b-4e8b-b427-ce7932454cdb	true	access.token.claim
7db30151-718b-4e8b-b427-ce7932454cdb	organization	claim.name
7db30151-718b-4e8b-b427-ce7932454cdb	String	jsonType.label
00d212eb-01d5-46b6-b5d5-6508de293795	true	introspection.token.claim
00d212eb-01d5-46b6-b5d5-6508de293795	true	userinfo.token.claim
00d212eb-01d5-46b6-b5d5-6508de293795	firstName	user.attribute
00d212eb-01d5-46b6-b5d5-6508de293795	true	id.token.claim
00d212eb-01d5-46b6-b5d5-6508de293795	true	access.token.claim
00d212eb-01d5-46b6-b5d5-6508de293795	given_name	claim.name
00d212eb-01d5-46b6-b5d5-6508de293795	String	jsonType.label
293b68fe-a088-464f-8670-dd211fd22480	true	id.token.claim
293b68fe-a088-464f-8670-dd211fd22480	true	introspection.token.claim
293b68fe-a088-464f-8670-dd211fd22480	true	access.token.claim
293b68fe-a088-464f-8670-dd211fd22480	true	userinfo.token.claim
35e8889d-ea7a-4b47-8187-04e1262168aa	true	introspection.token.claim
35e8889d-ea7a-4b47-8187-04e1262168aa	true	userinfo.token.claim
35e8889d-ea7a-4b47-8187-04e1262168aa	birthdate	user.attribute
35e8889d-ea7a-4b47-8187-04e1262168aa	true	id.token.claim
35e8889d-ea7a-4b47-8187-04e1262168aa	true	access.token.claim
35e8889d-ea7a-4b47-8187-04e1262168aa	birthdate	claim.name
35e8889d-ea7a-4b47-8187-04e1262168aa	String	jsonType.label
38a7f9db-01b8-415a-b6bf-70ae1c4eef65	true	introspection.token.claim
38a7f9db-01b8-415a-b6bf-70ae1c4eef65	true	userinfo.token.claim
38a7f9db-01b8-415a-b6bf-70ae1c4eef65	lastName	user.attribute
38a7f9db-01b8-415a-b6bf-70ae1c4eef65	true	id.token.claim
38a7f9db-01b8-415a-b6bf-70ae1c4eef65	true	access.token.claim
38a7f9db-01b8-415a-b6bf-70ae1c4eef65	family_name	claim.name
38a7f9db-01b8-415a-b6bf-70ae1c4eef65	String	jsonType.label
395a99cd-b0f0-4cf2-ac8b-eb4807e0292d	true	introspection.token.claim
395a99cd-b0f0-4cf2-ac8b-eb4807e0292d	true	userinfo.token.claim
395a99cd-b0f0-4cf2-ac8b-eb4807e0292d	locale	user.attribute
395a99cd-b0f0-4cf2-ac8b-eb4807e0292d	true	id.token.claim
395a99cd-b0f0-4cf2-ac8b-eb4807e0292d	true	access.token.claim
395a99cd-b0f0-4cf2-ac8b-eb4807e0292d	locale	claim.name
395a99cd-b0f0-4cf2-ac8b-eb4807e0292d	String	jsonType.label
7b8aaffb-fd08-4676-8e3c-9e4831d00fb9	true	introspection.token.claim
7b8aaffb-fd08-4676-8e3c-9e4831d00fb9	true	userinfo.token.claim
7b8aaffb-fd08-4676-8e3c-9e4831d00fb9	picture	user.attribute
7b8aaffb-fd08-4676-8e3c-9e4831d00fb9	true	id.token.claim
7b8aaffb-fd08-4676-8e3c-9e4831d00fb9	true	access.token.claim
7b8aaffb-fd08-4676-8e3c-9e4831d00fb9	picture	claim.name
7b8aaffb-fd08-4676-8e3c-9e4831d00fb9	String	jsonType.label
7fc105b8-8b25-4cb4-9cd0-214a89fd378a	true	introspection.token.claim
7fc105b8-8b25-4cb4-9cd0-214a89fd378a	true	userinfo.token.claim
7fc105b8-8b25-4cb4-9cd0-214a89fd378a	zoneinfo	user.attribute
7fc105b8-8b25-4cb4-9cd0-214a89fd378a	true	id.token.claim
7fc105b8-8b25-4cb4-9cd0-214a89fd378a	true	access.token.claim
7fc105b8-8b25-4cb4-9cd0-214a89fd378a	zoneinfo	claim.name
7fc105b8-8b25-4cb4-9cd0-214a89fd378a	String	jsonType.label
92c4861f-a91b-4498-99d6-975c61de6893	true	introspection.token.claim
92c4861f-a91b-4498-99d6-975c61de6893	true	userinfo.token.claim
92c4861f-a91b-4498-99d6-975c61de6893	profile	user.attribute
92c4861f-a91b-4498-99d6-975c61de6893	true	id.token.claim
92c4861f-a91b-4498-99d6-975c61de6893	true	access.token.claim
92c4861f-a91b-4498-99d6-975c61de6893	profile	claim.name
92c4861f-a91b-4498-99d6-975c61de6893	String	jsonType.label
a7773429-78c2-4927-a68c-acf262d05221	true	introspection.token.claim
a7773429-78c2-4927-a68c-acf262d05221	true	userinfo.token.claim
a7773429-78c2-4927-a68c-acf262d05221	username	user.attribute
a7773429-78c2-4927-a68c-acf262d05221	true	id.token.claim
a7773429-78c2-4927-a68c-acf262d05221	true	access.token.claim
a7773429-78c2-4927-a68c-acf262d05221	preferred_username	claim.name
a7773429-78c2-4927-a68c-acf262d05221	String	jsonType.label
d9e2620b-5e17-4bec-b2d9-be8f21b464cb	true	introspection.token.claim
d9e2620b-5e17-4bec-b2d9-be8f21b464cb	true	userinfo.token.claim
d9e2620b-5e17-4bec-b2d9-be8f21b464cb	middleName	user.attribute
d9e2620b-5e17-4bec-b2d9-be8f21b464cb	true	id.token.claim
d9e2620b-5e17-4bec-b2d9-be8f21b464cb	true	access.token.claim
d9e2620b-5e17-4bec-b2d9-be8f21b464cb	middle_name	claim.name
d9e2620b-5e17-4bec-b2d9-be8f21b464cb	String	jsonType.label
de8ad1a5-2440-4f3d-b34b-a5006cf4ebec	true	introspection.token.claim
de8ad1a5-2440-4f3d-b34b-a5006cf4ebec	true	userinfo.token.claim
de8ad1a5-2440-4f3d-b34b-a5006cf4ebec	nickname	user.attribute
de8ad1a5-2440-4f3d-b34b-a5006cf4ebec	true	id.token.claim
de8ad1a5-2440-4f3d-b34b-a5006cf4ebec	true	access.token.claim
de8ad1a5-2440-4f3d-b34b-a5006cf4ebec	nickname	claim.name
de8ad1a5-2440-4f3d-b34b-a5006cf4ebec	String	jsonType.label
fcd4f406-7ec0-4438-a9f7-055ecc2530ef	true	introspection.token.claim
fcd4f406-7ec0-4438-a9f7-055ecc2530ef	true	userinfo.token.claim
fcd4f406-7ec0-4438-a9f7-055ecc2530ef	gender	user.attribute
fcd4f406-7ec0-4438-a9f7-055ecc2530ef	true	id.token.claim
fcd4f406-7ec0-4438-a9f7-055ecc2530ef	true	access.token.claim
fcd4f406-7ec0-4438-a9f7-055ecc2530ef	gender	claim.name
fcd4f406-7ec0-4438-a9f7-055ecc2530ef	String	jsonType.label
fd5b99a4-55b6-4e26-9db2-f0b921b5de71	true	introspection.token.claim
fd5b99a4-55b6-4e26-9db2-f0b921b5de71	true	userinfo.token.claim
fd5b99a4-55b6-4e26-9db2-f0b921b5de71	website	user.attribute
fd5b99a4-55b6-4e26-9db2-f0b921b5de71	true	id.token.claim
fd5b99a4-55b6-4e26-9db2-f0b921b5de71	true	access.token.claim
fd5b99a4-55b6-4e26-9db2-f0b921b5de71	website	claim.name
fd5b99a4-55b6-4e26-9db2-f0b921b5de71	String	jsonType.label
fe33b2ef-1731-42cb-a052-6183b0a48317	true	introspection.token.claim
fe33b2ef-1731-42cb-a052-6183b0a48317	true	userinfo.token.claim
fe33b2ef-1731-42cb-a052-6183b0a48317	updatedAt	user.attribute
fe33b2ef-1731-42cb-a052-6183b0a48317	true	id.token.claim
fe33b2ef-1731-42cb-a052-6183b0a48317	true	access.token.claim
fe33b2ef-1731-42cb-a052-6183b0a48317	updated_at	claim.name
fe33b2ef-1731-42cb-a052-6183b0a48317	long	jsonType.label
7dd48cb9-01d0-4b51-b52b-1354faf6af82	AUTH_TIME	user.session.note
7dd48cb9-01d0-4b51-b52b-1354faf6af82	true	introspection.token.claim
7dd48cb9-01d0-4b51-b52b-1354faf6af82	true	userinfo.token.claim
7dd48cb9-01d0-4b51-b52b-1354faf6af82	true	id.token.claim
7dd48cb9-01d0-4b51-b52b-1354faf6af82	true	access.token.claim
7dd48cb9-01d0-4b51-b52b-1354faf6af82	auth_time	claim.name
7dd48cb9-01d0-4b51-b52b-1354faf6af82	long	jsonType.label
ef392c07-0536-4744-a93a-292f8d4be30f	true	introspection.token.claim
ef392c07-0536-4744-a93a-292f8d4be30f	true	access.token.claim
4edd640a-954b-4b4d-8c2a-dc0735636f7b	true	introspection.token.claim
4edd640a-954b-4b4d-8c2a-dc0735636f7b	true	userinfo.token.claim
4edd640a-954b-4b4d-8c2a-dc0735636f7b	emailVerified	user.attribute
4edd640a-954b-4b4d-8c2a-dc0735636f7b	true	id.token.claim
4edd640a-954b-4b4d-8c2a-dc0735636f7b	true	access.token.claim
4edd640a-954b-4b4d-8c2a-dc0735636f7b	email_verified	claim.name
4edd640a-954b-4b4d-8c2a-dc0735636f7b	boolean	jsonType.label
d34a981d-b8e7-468b-857f-d171431008fa	true	introspection.token.claim
d34a981d-b8e7-468b-857f-d171431008fa	true	userinfo.token.claim
d34a981d-b8e7-468b-857f-d171431008fa	email	user.attribute
d34a981d-b8e7-468b-857f-d171431008fa	true	id.token.claim
d34a981d-b8e7-468b-857f-d171431008fa	true	access.token.claim
d34a981d-b8e7-468b-857f-d171431008fa	email	claim.name
d34a981d-b8e7-468b-857f-d171431008fa	String	jsonType.label
0476f038-5793-43e1-b2f5-ff73109f4acd	true	introspection.token.claim
0476f038-5793-43e1-b2f5-ff73109f4acd	true	access.token.claim
1aab1b6e-6475-4f3d-a583-ebab611ccb95	foo	user.attribute
1aab1b6e-6475-4f3d-a583-ebab611ccb95	true	introspection.token.claim
1aab1b6e-6475-4f3d-a583-ebab611ccb95	true	access.token.claim
1aab1b6e-6475-4f3d-a583-ebab611ccb95	realm_access.roles	claim.name
1aab1b6e-6475-4f3d-a583-ebab611ccb95	String	jsonType.label
1aab1b6e-6475-4f3d-a583-ebab611ccb95	true	multivalued
dffa3157-9066-460a-acde-6f76917eaf58	foo	user.attribute
dffa3157-9066-460a-acde-6f76917eaf58	true	introspection.token.claim
dffa3157-9066-460a-acde-6f76917eaf58	true	access.token.claim
dffa3157-9066-460a-acde-6f76917eaf58	resource_access.${client_id}.roles	claim.name
dffa3157-9066-460a-acde-6f76917eaf58	String	jsonType.label
dffa3157-9066-460a-acde-6f76917eaf58	true	multivalued
5a735885-7e15-446d-9f72-b272e6bb8523	true	introspection.token.claim
5a735885-7e15-446d-9f72-b272e6bb8523	true	access.token.claim
b2514cf3-1e08-4a6c-874a-93c408c7cda3	formatted	user.attribute.formatted
b2514cf3-1e08-4a6c-874a-93c408c7cda3	country	user.attribute.country
b2514cf3-1e08-4a6c-874a-93c408c7cda3	true	introspection.token.claim
b2514cf3-1e08-4a6c-874a-93c408c7cda3	postal_code	user.attribute.postal_code
b2514cf3-1e08-4a6c-874a-93c408c7cda3	true	userinfo.token.claim
b2514cf3-1e08-4a6c-874a-93c408c7cda3	street	user.attribute.street
b2514cf3-1e08-4a6c-874a-93c408c7cda3	true	id.token.claim
b2514cf3-1e08-4a6c-874a-93c408c7cda3	region	user.attribute.region
b2514cf3-1e08-4a6c-874a-93c408c7cda3	true	access.token.claim
b2514cf3-1e08-4a6c-874a-93c408c7cda3	locality	user.attribute.locality
a32a1db1-71e2-40ed-82f5-47b13bc6de75	false	single
a32a1db1-71e2-40ed-82f5-47b13bc6de75	Basic	attribute.nameformat
a32a1db1-71e2-40ed-82f5-47b13bc6de75	Role	attribute.name
110a70c7-23d4-4057-8b83-2889fa1d7de0	true	introspection.token.claim
110a70c7-23d4-4057-8b83-2889fa1d7de0	true	userinfo.token.claim
110a70c7-23d4-4057-8b83-2889fa1d7de0	phoneNumberVerified	user.attribute
110a70c7-23d4-4057-8b83-2889fa1d7de0	true	id.token.claim
110a70c7-23d4-4057-8b83-2889fa1d7de0	true	access.token.claim
110a70c7-23d4-4057-8b83-2889fa1d7de0	phone_number_verified	claim.name
110a70c7-23d4-4057-8b83-2889fa1d7de0	boolean	jsonType.label
e77cb75e-8daa-41e0-94ad-960241c0e49c	true	introspection.token.claim
e77cb75e-8daa-41e0-94ad-960241c0e49c	true	userinfo.token.claim
e77cb75e-8daa-41e0-94ad-960241c0e49c	phoneNumber	user.attribute
e77cb75e-8daa-41e0-94ad-960241c0e49c	true	id.token.claim
e77cb75e-8daa-41e0-94ad-960241c0e49c	true	access.token.claim
e77cb75e-8daa-41e0-94ad-960241c0e49c	phone_number	claim.name
e77cb75e-8daa-41e0-94ad-960241c0e49c	String	jsonType.label
4584acc2-8518-460a-ac8e-98a0ce64da05	true	introspection.token.claim
4584acc2-8518-460a-ac8e-98a0ce64da05	true	userinfo.token.claim
4584acc2-8518-460a-ac8e-98a0ce64da05	username	user.attribute
4584acc2-8518-460a-ac8e-98a0ce64da05	true	id.token.claim
4584acc2-8518-460a-ac8e-98a0ce64da05	true	access.token.claim
4584acc2-8518-460a-ac8e-98a0ce64da05	upn	claim.name
4584acc2-8518-460a-ac8e-98a0ce64da05	String	jsonType.label
dc996a1c-997b-41ab-9e5c-3ee8c562e45e	true	introspection.token.claim
dc996a1c-997b-41ab-9e5c-3ee8c562e45e	true	multivalued
dc996a1c-997b-41ab-9e5c-3ee8c562e45e	true	userinfo.token.claim
dc996a1c-997b-41ab-9e5c-3ee8c562e45e	foo	user.attribute
dc996a1c-997b-41ab-9e5c-3ee8c562e45e	true	id.token.claim
dc996a1c-997b-41ab-9e5c-3ee8c562e45e	true	access.token.claim
dc996a1c-997b-41ab-9e5c-3ee8c562e45e	groups	claim.name
dc996a1c-997b-41ab-9e5c-3ee8c562e45e	String	jsonType.label
244b6e81-075f-4cfa-b096-aa4684826425	parkigo	clientId
244b6e81-075f-4cfa-b096-aa4684826425	true	userinfo.token.claim
244b6e81-075f-4cfa-b096-aa4684826425	true	multivalued
244b6e81-075f-4cfa-b096-aa4684826425	true	id.token.claim
244b6e81-075f-4cfa-b096-aa4684826425	true	access.token.claim
244b6e81-075f-4cfa-b096-aa4684826425	roles	claim.name
244b6e81-075f-4cfa-b096-aa4684826425	String	jsonType.label
bfe6ec87-fd46-4d4f-872c-3181f3a96bdd	true	introspection.token.claim
bfe6ec87-fd46-4d4f-872c-3181f3a96bdd	true	userinfo.token.claim
bfe6ec87-fd46-4d4f-872c-3181f3a96bdd	locale	user.attribute
bfe6ec87-fd46-4d4f-872c-3181f3a96bdd	true	id.token.claim
bfe6ec87-fd46-4d4f-872c-3181f3a96bdd	true	access.token.claim
bfe6ec87-fd46-4d4f-872c-3181f3a96bdd	locale	claim.name
bfe6ec87-fd46-4d4f-872c-3181f3a96bdd	String	jsonType.label
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	60	300	300	\N	\N	\N	t	f	0	\N	nextjs-dashboard	0	\N	t	f	t	f	EXTERNAL	1800	36000	f	t	e2f838fd-e179-4ed2-b8f9-c210ded0b1e3	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	11d4a136-08ef-4185-879e-20a7e5e71ea0	58806ca6-b5ca-4f7f-9550-a8cec9066c73	8de5f3d7-1fd9-4859-97bb-5859d47db91c	1c24920f-adcf-403f-aeee-622e2218c632	f7ba0e0f-7be0-458e-aae1-6e59a6b35aec	2592000	f	900	t	f	478c5259-862d-4db9-a2ea-bd0887d86ee9	0	f	0	0	32d78998-b4a3-4358-9f41-9fb89659de0b
b438138c-504f-4895-bc39-d44717b59327	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	81d75f2a-0d5b-4e52-8e6d-a85004fca6bb	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	b6ba99d2-5883-4a3c-b784-c3e943194864	2b2b334a-1572-4f24-aee4-033e5f2a9e22	577dba76-0d2c-4fe2-af5d-15a8c0261f39	27ee01e9-fcf9-4177-bec2-404aef9d5879	406ec97c-1681-463e-9496-8e966798cb5f	2592000	f	900	t	f	7c60623f-8232-400d-b9b1-b1a2aad8547e	0	f	0	0	771027ff-f167-418e-9bfc-b15568615f00
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	b438138c-504f-4895-bc39-d44717b59327	
_browser_header.xContentTypeOptions	b438138c-504f-4895-bc39-d44717b59327	nosniff
_browser_header.referrerPolicy	b438138c-504f-4895-bc39-d44717b59327	no-referrer
_browser_header.xRobotsTag	b438138c-504f-4895-bc39-d44717b59327	none
_browser_header.xFrameOptions	b438138c-504f-4895-bc39-d44717b59327	SAMEORIGIN
_browser_header.contentSecurityPolicy	b438138c-504f-4895-bc39-d44717b59327	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.strictTransportSecurity	b438138c-504f-4895-bc39-d44717b59327	max-age=31536000; includeSubDomains
bruteForceProtected	b438138c-504f-4895-bc39-d44717b59327	false
permanentLockout	b438138c-504f-4895-bc39-d44717b59327	false
maxTemporaryLockouts	b438138c-504f-4895-bc39-d44717b59327	0
bruteForceStrategy	b438138c-504f-4895-bc39-d44717b59327	MULTIPLE
maxFailureWaitSeconds	b438138c-504f-4895-bc39-d44717b59327	900
minimumQuickLoginWaitSeconds	b438138c-504f-4895-bc39-d44717b59327	60
waitIncrementSeconds	b438138c-504f-4895-bc39-d44717b59327	60
quickLoginCheckMilliSeconds	b438138c-504f-4895-bc39-d44717b59327	1000
maxDeltaTimeSeconds	b438138c-504f-4895-bc39-d44717b59327	43200
failureFactor	b438138c-504f-4895-bc39-d44717b59327	30
realmReusableOtpCode	b438138c-504f-4895-bc39-d44717b59327	false
firstBrokerLoginFlowId	b438138c-504f-4895-bc39-d44717b59327	3236e8e9-efe1-4d6c-8424-f3a54e2d1a75
displayName	b438138c-504f-4895-bc39-d44717b59327	Keycloak
displayNameHtml	b438138c-504f-4895-bc39-d44717b59327	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	b438138c-504f-4895-bc39-d44717b59327	RS256
offlineSessionMaxLifespanEnabled	b438138c-504f-4895-bc39-d44717b59327	false
offlineSessionMaxLifespan	b438138c-504f-4895-bc39-d44717b59327	5184000
_browser_header.contentSecurityPolicyReportOnly	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	
_browser_header.xContentTypeOptions	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	nosniff
_browser_header.referrerPolicy	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	no-referrer
_browser_header.xRobotsTag	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	none
_browser_header.xFrameOptions	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	SAMEORIGIN
_browser_header.contentSecurityPolicy	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.strictTransportSecurity	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	max-age=31536000; includeSubDomains
bruteForceProtected	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	false
permanentLockout	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	false
maxTemporaryLockouts	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	0
bruteForceStrategy	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	MULTIPLE
maxFailureWaitSeconds	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	900
minimumQuickLoginWaitSeconds	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	60
waitIncrementSeconds	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	60
quickLoginCheckMilliSeconds	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	1000
maxDeltaTimeSeconds	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	43200
failureFactor	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	30
realmReusableOtpCode	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	false
defaultSignatureAlgorithm	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	RS256
offlineSessionMaxLifespanEnabled	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	false
offlineSessionMaxLifespan	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	5184000
clientSessionIdleTimeout	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	0
clientSessionMaxLifespan	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	0
clientOfflineSessionIdleTimeout	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	0
clientOfflineSessionMaxLifespan	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	0
actionTokenGeneratedByAdminLifespan	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	43200
actionTokenGeneratedByUserLifespan	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	300
oauth2DeviceCodeLifespan	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	600
oauth2DevicePollingInterval	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	5
organizationsEnabled	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	false
adminPermissionsEnabled	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	false
webAuthnPolicyRpEntityName	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	keycloak
webAuthnPolicySignatureAlgorithms	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	ES256,RS256
webAuthnPolicyRpId	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	
webAuthnPolicyAttestationConveyancePreference	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	not specified
webAuthnPolicyAuthenticatorAttachment	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	not specified
webAuthnPolicyRequireResidentKey	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	not specified
webAuthnPolicyUserVerificationRequirement	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	not specified
webAuthnPolicyCreateTimeout	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	0
webAuthnPolicyAvoidSameAuthenticatorRegister	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	false
webAuthnPolicyRpEntityNamePasswordless	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	keycloak
webAuthnPolicySignatureAlgorithmsPasswordless	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	ES256,RS256
webAuthnPolicyRpIdPasswordless	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	
webAuthnPolicyAttestationConveyancePreferencePasswordless	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	not specified
webAuthnPolicyRequireResidentKeyPasswordless	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	not specified
webAuthnPolicyUserVerificationRequirementPasswordless	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	not specified
webAuthnPolicyCreateTimeoutPasswordless	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	false
cibaBackchannelTokenDeliveryMode	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	poll
cibaExpiresIn	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	120
cibaInterval	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	5
cibaAuthRequestedUserHint	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	login_hint
parRequestUriLifespan	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	60
firstBrokerLoginFlowId	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2a26e08e-2278-4d56-931b-12601113607f
verifiableCredentialsEnabled	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	false
client-policies.profiles	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	{"profiles":[]}
client-policies.policies	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	{"policies":[]}
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
b438138c-504f-4895-bc39-d44717b59327	jboss-logging
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	b438138c-504f-4895-bc39-d44717b59327
password	password	t	t	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.redirect_uris (client_id, value) FROM stdin;
adaa41f0-3a6d-4d36-afff-d00455b42e38	/realms/master/account/*
e549e6ec-8bb9-4897-ae6b-89e65040fc57	/realms/master/account/*
e5a66eb0-ba52-4ce5-9f3a-d7ad118df926	/admin/master/console/*
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	/realms/nextjs-dashboard/account/*
6594bd92-c078-437d-aa19-32810411fe71	/realms/nextjs-dashboard/account/*
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	http://localhost:3000/*
b323fd36-7155-40a7-9eb1-94d315656e84	/admin/nextjs-dashboard/console/*
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
d21c00cf-eaaf-488d-8b05-2c760207133d	VERIFY_EMAIL	Verify Email	b438138c-504f-4895-bc39-d44717b59327	t	f	VERIFY_EMAIL	50
648b0d94-399c-447a-b748-361b51bd0fe7	UPDATE_PROFILE	Update Profile	b438138c-504f-4895-bc39-d44717b59327	t	f	UPDATE_PROFILE	40
f087f3b3-e6c3-455a-8571-4c8a2104e4d0	CONFIGURE_TOTP	Configure OTP	b438138c-504f-4895-bc39-d44717b59327	t	f	CONFIGURE_TOTP	10
630ecf14-f928-42d8-aff2-e334ad51a741	UPDATE_PASSWORD	Update Password	b438138c-504f-4895-bc39-d44717b59327	t	f	UPDATE_PASSWORD	30
33be551b-4134-45ca-ad7e-9b08d1d395c8	TERMS_AND_CONDITIONS	Terms and Conditions	b438138c-504f-4895-bc39-d44717b59327	f	f	TERMS_AND_CONDITIONS	20
17d74185-8614-4eb9-b172-31fd8bf3bc2c	delete_account	Delete Account	b438138c-504f-4895-bc39-d44717b59327	f	f	delete_account	60
b945b270-6b59-4b75-86fb-3f9492675b1c	delete_credential	Delete Credential	b438138c-504f-4895-bc39-d44717b59327	t	f	delete_credential	100
e41db84d-43fe-489d-9ea6-ea52dde6cde0	update_user_locale	Update User Locale	b438138c-504f-4895-bc39-d44717b59327	t	f	update_user_locale	1000
bdbbc077-c415-4374-be41-bb5c9082a337	CONFIGURE_RECOVERY_AUTHN_CODES	Recovery Authentication Codes	b438138c-504f-4895-bc39-d44717b59327	t	f	CONFIGURE_RECOVERY_AUTHN_CODES	120
e7a8d289-3df1-4920-8775-ddc0dfd322b4	webauthn-register	Webauthn Register	b438138c-504f-4895-bc39-d44717b59327	t	f	webauthn-register	70
a7d70bef-944a-4b96-b53e-fdfb57d4552b	webauthn-register-passwordless	Webauthn Register Passwordless	b438138c-504f-4895-bc39-d44717b59327	t	f	webauthn-register-passwordless	80
3cd4839b-c6f1-40ed-8967-59faf892897d	VERIFY_PROFILE	Verify Profile	b438138c-504f-4895-bc39-d44717b59327	t	f	VERIFY_PROFILE	90
2b4b8d32-6542-4d50-a08f-45e124466cf0	idp_link	Linking Identity Provider	b438138c-504f-4895-bc39-d44717b59327	t	f	idp_link	110
0230f74b-0144-47a2-9cf5-0aa7dd13fe50	CONFIGURE_TOTP	Configure OTP	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	t	f	CONFIGURE_TOTP	10
029981b7-a467-4e20-ac08-e8dd449aa6ad	TERMS_AND_CONDITIONS	Terms and Conditions	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	f	f	TERMS_AND_CONDITIONS	20
b1e7f4fd-036d-4710-9675-964871a6a882	UPDATE_PASSWORD	Update Password	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	t	f	UPDATE_PASSWORD	30
56ae68fc-c775-4269-82e8-b488e181c593	UPDATE_PROFILE	Update Profile	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	t	f	UPDATE_PROFILE	40
1336cf1d-fa4b-4031-8e5c-caadd4b6085c	VERIFY_EMAIL	Verify Email	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	t	f	VERIFY_EMAIL	50
3b1213b8-b380-409c-a235-bd5b209a509d	delete_account	Delete Account	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	f	f	delete_account	60
ed0f2b24-1491-4ee6-a31b-30e48ece858d	webauthn-register	Webauthn Register	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	t	f	webauthn-register	70
799e6d5e-b237-411e-907d-9527fa023b72	webauthn-register-passwordless	Webauthn Register Passwordless	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	t	f	webauthn-register-passwordless	80
34f51da2-ed65-4cd6-b31a-3d203cbc498e	VERIFY_PROFILE	Verify Profile	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	t	f	VERIFY_PROFILE	90
2640882f-4292-4b03-b2f3-cd4b4fe18eee	delete_credential	Delete Credential	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	t	f	delete_credential	100
29d7c78d-d52b-44a1-8c00-cabf3f1031d5	update_user_locale	Update User Locale	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	t	f	update_user_locale	1000
bde4dec9-0e6f-4a40-9fbf-541bb6322fd3	idp_link	Linking Identity Provider	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	t	f	idp_link	110
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: revoked_token; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.revoked_token (id, expire) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
e549e6ec-8bb9-4897-ae6b-89e65040fc57	cff0a2de-c74b-4e9f-839a-8fd1486603b7
e549e6ec-8bb9-4897-ae6b-89e65040fc57	ebbdf1e0-1173-4921-8973-269edb22361a
6594bd92-c078-437d-aa19-32810411fe71	e5ca7bde-db56-490d-afe1-25f4d5636935
6594bd92-c078-437d-aa19-32810411fe71	288cb142-db49-44cc-bd8f-cfd2131bd52b
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: server_config; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.server_config (server_config_key, value, version) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.user_attribute (name, value, user_id, id, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
is_temporary_admin	true	999640a9-7a0a-4dd2-ad6b-61ddbab3c82e	bdbb5327-795a-41a4-9e86-94e3d6449a2b	\N	\N	\N
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
999640a9-7a0a-4dd2-ad6b-61ddbab3c82e	\N	b8af5e0b-97e1-4b5f-b364-be4283204b80	f	t	\N	\N	\N	b438138c-504f-4895-bc39-d44717b59327	admin	1752160547764	\N	0
e4d137a8-ca21-4bd5-80dc-69cee3432bdb	admin@parkigo.be	admin@parkigo.be	t	t	\N	Admin	ParkiGo	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	admin	\N	\N	0
b1c7bfb6-8279-42c6-8cd5-2ac227717fb1	delvauxo@outlook.com	delvauxo@outlook.com	t	t	\N	Olivier	Delvaux	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	delvauxo	1750959726388	\N	0
ecacf8de-e81a-4ca7-83d6-d7fc200bf9a4	owner@parkigo.be	owner@parkigo.be	t	t	\N	Owner	ParkiGo	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	owner	\N	\N	0
ecacf8de-e81a-4ca7-83d6-d7fc202gg9a4	tester@parkigo.be	tester@parkigo.be	t	t	\N	Tester	ParkiGo	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	tester	\N	\N	0
15d36145-5cea-49e5-9f9f-fe71bfe502fb	renter@parkigo.be	renter@parkigo.be	t	t	\N	Renter	ParkiGo	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	renter	\N	\N	0
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.user_group_membership (group_id, user_id, membership_type) FROM stdin;
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
771027ff-f167-418e-9bfc-b15568615f00	999640a9-7a0a-4dd2-ad6b-61ddbab3c82e
f2e59d02-cda8-47ef-a67c-fc64c9bd5850	999640a9-7a0a-4dd2-ad6b-61ddbab3c82e
38a16972-2598-4dd5-b2de-5a108ce9c748	e4d137a8-ca21-4bd5-80dc-69cee3432bdb
32d78998-b4a3-4358-9f41-9fb89659de0b	b1c7bfb6-8279-42c6-8cd5-2ac227717fb1
1fbe4fc6-50aa-45e4-adbf-f7b73d0e1836	ecacf8de-e81a-4ca7-83d6-d7fc200bf9a4
a0d9da8b-2f4f-4508-a7b2-421220c701ab	ecacf8de-e81a-4ca7-83d6-d7fc202gg9a4
f509302a-4f0d-488f-ac8e-3b2858c5de9f	15d36145-5cea-49e5-9f9f-fe71bfe502fb
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.web_origins (client_id, value) FROM stdin;
e5a66eb0-ba52-4ce5-9f3a-d7ad118df926	+
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	http://localhost:3000
b323fd36-7155-40a7-9eb1-94d315656e84	+
\.


--
-- Name: org_domain ORG_DOMAIN_pkey; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.org_domain
    ADD CONSTRAINT "ORG_DOMAIN_pkey" PRIMARY KEY (id, name);


--
-- Name: org ORG_pkey; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT "ORG_pkey" PRIMARY KEY (id);


--
-- Name: server_config SERVER_CONFIG_pkey; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.server_config
    ADD CONSTRAINT "SERVER_CONFIG_pkey" PRIMARY KEY (server_config_key);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: jgroups_ping constraint_jgroups_ping; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.jgroups_ping
    ADD CONSTRAINT constraint_jgroups_ping PRIMARY KEY (address);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: revoked_token constraint_rt; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.revoked_token
    ADD CONSTRAINT constraint_rt PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: user_consent uk_external_consent; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_external_consent UNIQUE (client_storage_provider, external_client_id, user_id);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: user_consent uk_local_consent; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_local_consent UNIQUE (client_id, user_id);


--
-- Name: migration_model uk_migration_update_time; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT uk_migration_update_time UNIQUE (update_time);


--
-- Name: migration_model uk_migration_version; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT uk_migration_version UNIQUE (version);


--
-- Name: org uk_org_alias; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_alias UNIQUE (realm_id, alias);


--
-- Name: org uk_org_group; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_group UNIQUE (group_id);


--
-- Name: org uk_org_name; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_name UNIQUE (realm_id, name);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: fed_user_attr_long_values; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX fed_user_attr_long_values ON public.fed_user_attribute USING btree (long_value_hash, name);


--
-- Name: fed_user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX fed_user_attr_long_values_lower_case ON public.fed_user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: idx_admin_event_time; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_admin_event_time ON public.admin_event_entity USING btree (realm_id, admin_event_time);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_att_by_name_value; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_client_att_by_name_value ON public.client_attributes USING btree (name, substr(value, 1, 255));


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_att_by_name_value; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_group_att_by_name_value ON public.group_attribute USING btree (name, ((value)::character varying(250)));


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_idp_for_login; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_idp_for_login ON public.identity_provider USING btree (realm_id, enabled, link_only, hide_on_login, organization_id);


--
-- Name: idx_idp_realm_org; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_idp_realm_org ON public.identity_provider USING btree (realm_id, organization_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_uss_by_broker_session_id; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_offline_uss_by_broker_session_id ON public.offline_user_session USING btree (broker_session_id, realm_id);


--
-- Name: idx_offline_uss_by_last_session_refresh; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_offline_uss_by_last_session_refresh ON public.offline_user_session USING btree (realm_id, offline_flag, last_session_refresh);


--
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- Name: idx_org_domain_org_id; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_org_domain_org_id ON public.org_domain USING btree (org_id);


--
-- Name: idx_perm_ticket_owner; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_perm_ticket_owner ON public.resource_server_perm_ticket USING btree (owner);


--
-- Name: idx_perm_ticket_requester; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_perm_ticket_requester ON public.resource_server_perm_ticket USING btree (requester);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_rev_token_on_expire; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_rev_token_on_expire ON public.revoked_token USING btree (expire);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_usconsent_scope_id; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_usconsent_scope_id ON public.user_consent_client_scope USING btree (scope_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_user_service_account; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_user_service_account ON public.user_entity USING btree (realm_id, service_account_client_link);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: user_attr_long_values; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX user_attr_long_values ON public.user_attribute USING btree (long_value_hash, name);


--
-- Name: user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: delvauxo
--

CREATE INDEX user_attr_long_values_lower_case ON public.user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: delvauxo
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- PostgreSQL database dump complete
--

