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
    type integer DEFAULT 0 NOT NULL
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
6e4c213b-6b53-445b-9d63-1bf6b98a3d5f	\N	auth-cookie	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	4a846dc6-2f5a-4511-be8b-7cb3b102b7b2	2	10	f	\N	\N
05886349-cc64-4752-9f8e-c179c76d896f	\N	auth-spnego	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	4a846dc6-2f5a-4511-be8b-7cb3b102b7b2	3	20	f	\N	\N
e4c5e15f-b12f-4fb3-b551-4ddd81730a4c	\N	identity-provider-redirector	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	4a846dc6-2f5a-4511-be8b-7cb3b102b7b2	2	25	f	\N	\N
19647bab-25e0-4b9a-a13f-49e8451e0173	\N	\N	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	4a846dc6-2f5a-4511-be8b-7cb3b102b7b2	2	30	t	cb87ec6f-6c80-4bf4-a473-8c5cb5a3960e	\N
3d5d94c3-bcb5-4929-a546-3b0b93f8c25f	\N	auth-username-password-form	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	cb87ec6f-6c80-4bf4-a473-8c5cb5a3960e	0	10	f	\N	\N
2f22174f-f590-491e-9f96-aeec9ea20cdf	\N	\N	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	cb87ec6f-6c80-4bf4-a473-8c5cb5a3960e	1	20	t	06d67977-b0bf-4b9a-9aef-93d0ceaf80db	\N
d5d4be9f-771f-4521-aa76-87cc8a76f1a3	\N	conditional-user-configured	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	06d67977-b0bf-4b9a-9aef-93d0ceaf80db	0	10	f	\N	\N
fa0445dc-91f4-4858-8e4c-e193b1246b29	\N	auth-otp-form	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	06d67977-b0bf-4b9a-9aef-93d0ceaf80db	0	20	f	\N	\N
f15ef5dd-bc84-4f7d-8d2f-2ba6d8db8084	\N	direct-grant-validate-username	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	bd4dfd9f-d75d-43ac-9c9f-a1d0f788dabf	0	10	f	\N	\N
6ad81051-4565-4ea1-b3ef-ed2e3da4c9e0	\N	direct-grant-validate-password	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	bd4dfd9f-d75d-43ac-9c9f-a1d0f788dabf	0	20	f	\N	\N
2b7d3f99-8928-4e94-ac5d-d4df01445bbc	\N	\N	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	bd4dfd9f-d75d-43ac-9c9f-a1d0f788dabf	1	30	t	0e6f1893-2a67-433f-812f-c8a0c2e17e44	\N
60181bbe-375b-4e91-922e-50c6c43631ee	\N	conditional-user-configured	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	0e6f1893-2a67-433f-812f-c8a0c2e17e44	0	10	f	\N	\N
be5d0475-90c9-4d9f-8383-765e6b5ac282	\N	direct-grant-validate-otp	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	0e6f1893-2a67-433f-812f-c8a0c2e17e44	0	20	f	\N	\N
47bd652b-9c82-4e8e-abf8-055255fd2161	\N	registration-page-form	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	b60df5bb-0405-4efb-bb7c-039a76420cbf	0	10	t	28d003f6-46a4-42a1-a279-46ec171018ec	\N
51c9bc56-e96e-49cd-ba41-2987e8ae4b09	\N	registration-user-creation	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	28d003f6-46a4-42a1-a279-46ec171018ec	0	20	f	\N	\N
dcf4a115-4120-4404-927c-1000db7db5e8	\N	registration-password-action	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	28d003f6-46a4-42a1-a279-46ec171018ec	0	50	f	\N	\N
5ba5b197-f9ec-4ea6-8aae-14eb3fe3bf1c	\N	registration-recaptcha-action	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	28d003f6-46a4-42a1-a279-46ec171018ec	3	60	f	\N	\N
da94518a-d593-4920-af0d-95c346909b74	\N	registration-terms-and-conditions	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	28d003f6-46a4-42a1-a279-46ec171018ec	3	70	f	\N	\N
cf248944-fd06-4064-8c11-b26cac9737b4	\N	reset-credentials-choose-user	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	9718049a-8296-4ce6-a2ef-fd27474a8ff6	0	10	f	\N	\N
c92fbeb7-777f-481e-a4f2-5e3b6740eb4e	\N	reset-credential-email	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	9718049a-8296-4ce6-a2ef-fd27474a8ff6	0	20	f	\N	\N
d5a3e5b4-7f5d-44fe-a498-7003c35596dc	\N	reset-password	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	9718049a-8296-4ce6-a2ef-fd27474a8ff6	0	30	f	\N	\N
a1c54c4a-1fae-4fbf-aa35-efd3332fda58	\N	\N	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	9718049a-8296-4ce6-a2ef-fd27474a8ff6	1	40	t	f84209ea-9421-4bb5-8c01-2b2b12d7bdba	\N
d9d6f2c8-e1a1-4c5e-bdb5-47005102831d	\N	conditional-user-configured	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	f84209ea-9421-4bb5-8c01-2b2b12d7bdba	0	10	f	\N	\N
1460ade1-0d2c-4538-8fdd-110ca960439f	\N	reset-otp	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	f84209ea-9421-4bb5-8c01-2b2b12d7bdba	0	20	f	\N	\N
63036126-c326-480f-94e5-ed8934be46df	\N	client-secret	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	a6d113ef-e81f-42ac-b1a1-18bf9f7883f8	2	10	f	\N	\N
b9ef6f35-d7b1-4789-8bba-f8dcf12e9a36	\N	client-jwt	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	a6d113ef-e81f-42ac-b1a1-18bf9f7883f8	2	20	f	\N	\N
4f3d4579-9515-4fe9-b52a-3644a4aad891	\N	client-secret-jwt	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	a6d113ef-e81f-42ac-b1a1-18bf9f7883f8	2	30	f	\N	\N
66444c9e-5df4-4e41-b5ad-0be58bf7cf05	\N	client-x509	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	a6d113ef-e81f-42ac-b1a1-18bf9f7883f8	2	40	f	\N	\N
cfe48688-5b38-4d2f-964a-dc0df133f1f7	\N	idp-review-profile	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	b52bd267-b851-43a1-8a88-7fa0693f0e0c	0	10	f	\N	9fc515ef-265f-41cb-9162-9e9aecc68824
d10536d7-3a1f-4a70-ace3-49385553418c	\N	\N	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	b52bd267-b851-43a1-8a88-7fa0693f0e0c	0	20	t	63973eeb-2e8e-414c-bc07-3cc75b7d8d94	\N
6245a0cc-6f1d-4bd5-bfd6-0491697bae8c	\N	idp-create-user-if-unique	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	63973eeb-2e8e-414c-bc07-3cc75b7d8d94	2	10	f	\N	f3911a1d-e9bd-4cc6-9607-755656449ab7
2c6753a1-3144-4e6f-9c1e-e3e4120b04f6	\N	\N	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	63973eeb-2e8e-414c-bc07-3cc75b7d8d94	2	20	t	5756c2f6-d8dd-4b03-8a52-f98435a425b1	\N
373d6025-1358-41d5-8355-4b5ae7969f0c	\N	idp-confirm-link	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	5756c2f6-d8dd-4b03-8a52-f98435a425b1	0	10	f	\N	\N
cb029be4-207c-4313-bb18-64d1f72d4547	\N	\N	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	5756c2f6-d8dd-4b03-8a52-f98435a425b1	0	20	t	504b701f-61d9-4123-9870-3cf9998f25bb	\N
5579c336-bcb7-495b-a152-a26f422a8e81	\N	idp-email-verification	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	504b701f-61d9-4123-9870-3cf9998f25bb	2	10	f	\N	\N
28fc1a8e-3c32-4bb5-9d44-f84886501035	\N	\N	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	504b701f-61d9-4123-9870-3cf9998f25bb	2	20	t	14dcc8bd-9012-40b4-aa73-2b1f4e8e1b37	\N
ca4c8b89-3ac7-4143-b446-38f78ceafd4f	\N	idp-username-password-form	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	14dcc8bd-9012-40b4-aa73-2b1f4e8e1b37	0	10	f	\N	\N
ea766686-117b-4493-9b5a-9b1b48f4ca36	\N	\N	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	14dcc8bd-9012-40b4-aa73-2b1f4e8e1b37	1	20	t	8201b84c-9740-49bb-ab6f-5aa6e62254fa	\N
2f182d67-4dfd-4d22-9968-e2091699b058	\N	conditional-user-configured	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	8201b84c-9740-49bb-ab6f-5aa6e62254fa	0	10	f	\N	\N
990cfe96-b21a-48e8-bf0e-7108d2d202ef	\N	auth-otp-form	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	8201b84c-9740-49bb-ab6f-5aa6e62254fa	0	20	f	\N	\N
3155d509-aa6d-4a2a-8c6a-4e472736e7c9	\N	http-basic-authenticator	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	5e103801-cb04-4753-a899-57b4ace4bac6	0	10	f	\N	\N
e3da1ae4-8530-4bec-96a5-02b1ebe81fb1	\N	docker-http-basic-authenticator	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	93510552-7da0-4d2f-8103-888e1c4267ac	0	10	f	\N	\N
ad7d9ee2-fb6d-4b16-b3f8-2d5c01a3364d	\N	auth-cookie	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	11d4a136-08ef-4185-879e-20a7e5e71ea0	2	10	f	\N	\N
98c2be8e-6720-4c51-a340-fc2065d5a0c4	\N	auth-spnego	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	11d4a136-08ef-4185-879e-20a7e5e71ea0	3	20	f	\N	\N
942349dd-37f6-4768-bb00-5efe6f60bb72	\N	identity-provider-redirector	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	11d4a136-08ef-4185-879e-20a7e5e71ea0	2	25	f	\N	\N
4faf302a-45e8-4928-92f5-7b19d0616162	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	11d4a136-08ef-4185-879e-20a7e5e71ea0	2	30	t	8340e02e-4a7f-4979-b060-e62241f68034	\N
04ff2ebf-d912-4a6a-b448-e0a21434c3d7	\N	auth-username-password-form	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	8340e02e-4a7f-4979-b060-e62241f68034	0	10	f	\N	\N
b672c240-da56-44da-beb5-97d550b12ec3	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	8340e02e-4a7f-4979-b060-e62241f68034	1	20	t	70a17c71-1e0e-4dcf-913e-e0b929c49a33	\N
9ad2b414-c3d4-4b33-99bf-9df13b2109a0	\N	conditional-user-configured	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	70a17c71-1e0e-4dcf-913e-e0b929c49a33	0	10	f	\N	\N
1ac3418a-c1cf-4307-b7f2-3edc5c5732df	\N	auth-otp-form	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	70a17c71-1e0e-4dcf-913e-e0b929c49a33	0	20	f	\N	\N
97c44a89-3c91-4a6d-9a8a-1365ab52f703	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	11d4a136-08ef-4185-879e-20a7e5e71ea0	2	26	t	e11b4410-776d-4f45-9da6-3d50fd0ecb57	\N
1b8d64a3-5b30-4e88-a1b0-ce6a73868e49	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	e11b4410-776d-4f45-9da6-3d50fd0ecb57	1	10	t	1892e93c-fde1-4fd3-b2dd-a1edd45ecd26	\N
7c53f293-4bfd-4e73-9638-640bd8119859	\N	conditional-user-configured	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	1892e93c-fde1-4fd3-b2dd-a1edd45ecd26	0	10	f	\N	\N
f67bdbc3-0cfc-4a7f-b9ac-23b0d534c849	\N	organization	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	1892e93c-fde1-4fd3-b2dd-a1edd45ecd26	2	20	f	\N	\N
bfbeec0b-44c1-4889-9def-1c65ae4a40a2	\N	direct-grant-validate-username	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	8de5f3d7-1fd9-4859-97bb-5859d47db91c	0	10	f	\N	\N
a6a8c9ce-2411-4a65-ae49-1a50a7c8031d	\N	direct-grant-validate-password	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	8de5f3d7-1fd9-4859-97bb-5859d47db91c	0	20	f	\N	\N
2cafe8b8-932f-4d06-bb29-82009f54a90c	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	8de5f3d7-1fd9-4859-97bb-5859d47db91c	1	30	t	58ccdd5d-9e47-42b0-b8d7-b89a064daa69	\N
4eb12396-1042-4585-a4f9-e1ceee13c2d0	\N	conditional-user-configured	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	58ccdd5d-9e47-42b0-b8d7-b89a064daa69	0	10	f	\N	\N
4c55566b-301a-4105-8ee0-aca78d8ad2a5	\N	direct-grant-validate-otp	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	58ccdd5d-9e47-42b0-b8d7-b89a064daa69	0	20	f	\N	\N
86bc2d0c-dbef-41f0-9981-b83687e09b90	\N	registration-page-form	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	58806ca6-b5ca-4f7f-9550-a8cec9066c73	0	10	t	5f09c312-15b0-4ae2-9f37-162501b73124	\N
770d04e1-46ee-4130-a301-6b5e78f41a4e	\N	registration-user-creation	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	5f09c312-15b0-4ae2-9f37-162501b73124	0	20	f	\N	\N
52c81756-2bc6-4460-adf2-1ea9a6a3eb2d	\N	registration-password-action	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	5f09c312-15b0-4ae2-9f37-162501b73124	0	50	f	\N	\N
14790901-491a-49ae-87cb-147b7208efff	\N	registration-recaptcha-action	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	5f09c312-15b0-4ae2-9f37-162501b73124	3	60	f	\N	\N
e2365565-5c75-42a8-aa3f-2609b8cae6b0	\N	registration-terms-and-conditions	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	5f09c312-15b0-4ae2-9f37-162501b73124	3	70	f	\N	\N
3ee4eeb8-5327-4deb-ae57-f9688df042f6	\N	reset-credentials-choose-user	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	1c24920f-adcf-403f-aeee-622e2218c632	0	10	f	\N	\N
5ded666a-28b8-4a51-9143-7c06dedd9e46	\N	reset-credential-email	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	1c24920f-adcf-403f-aeee-622e2218c632	0	20	f	\N	\N
1237a794-3c48-49e7-9b0d-662ab6655c63	\N	reset-password	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	1c24920f-adcf-403f-aeee-622e2218c632	0	30	f	\N	\N
ecfa6bde-9590-4264-9403-94edb7e03319	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	1c24920f-adcf-403f-aeee-622e2218c632	1	40	t	24080a19-f1bd-451a-bbb5-af9f3d658205	\N
c75b0fb8-be4f-4180-8922-d5c088300b4d	\N	conditional-user-configured	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	24080a19-f1bd-451a-bbb5-af9f3d658205	0	10	f	\N	\N
78eb64e5-94e0-4faf-99c9-51e7efa1378b	\N	reset-otp	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	24080a19-f1bd-451a-bbb5-af9f3d658205	0	20	f	\N	\N
16d9af77-6e2b-4fef-bd39-5d8fa63fc13d	\N	client-secret	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	f7ba0e0f-7be0-458e-aae1-6e59a6b35aec	2	10	f	\N	\N
791079fc-d486-45cb-9508-1515439c2e73	\N	client-jwt	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	f7ba0e0f-7be0-458e-aae1-6e59a6b35aec	2	20	f	\N	\N
c83d2b42-a1a6-4b4f-b35f-c2d6982faa7c	\N	client-secret-jwt	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	f7ba0e0f-7be0-458e-aae1-6e59a6b35aec	2	30	f	\N	\N
da1373e0-5a50-4726-9db3-62ea8246de12	\N	client-x509	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	f7ba0e0f-7be0-458e-aae1-6e59a6b35aec	2	40	f	\N	\N
36cb77c6-bb50-4e02-9075-e1145a584ea3	\N	idp-review-profile	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2a26e08e-2278-4d56-931b-12601113607f	0	10	f	\N	e91259f8-3397-41af-87d9-78354e82655d
31166ce4-8e23-4396-be5d-3461d618ceeb	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2a26e08e-2278-4d56-931b-12601113607f	0	20	t	4abee144-ad13-44f6-9b23-b8b11d5e8149	\N
a9c572d0-3025-4e66-8f95-bc107e71c3ba	\N	idp-create-user-if-unique	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	4abee144-ad13-44f6-9b23-b8b11d5e8149	2	10	f	\N	842f0ae4-5ec3-438f-8567-714ee5373efc
19f7bf39-6960-4a6c-aa46-587ca152e86f	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	4abee144-ad13-44f6-9b23-b8b11d5e8149	2	20	t	e156e078-07ed-4bec-ad4c-4f19508ea595	\N
ba0c3885-2199-4312-b8b9-d779abc7f730	\N	idp-confirm-link	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	e156e078-07ed-4bec-ad4c-4f19508ea595	0	10	f	\N	\N
668036f0-b0e8-47fa-8025-0abd527efc87	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	e156e078-07ed-4bec-ad4c-4f19508ea595	0	20	t	dca62b1f-e764-4007-b9ef-b8f0e703bd00	\N
c5a0126b-c475-4c5b-b265-a6bde66549c6	\N	idp-email-verification	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	dca62b1f-e764-4007-b9ef-b8f0e703bd00	2	10	f	\N	\N
f313b040-2e4e-4d96-88fe-3c777c5d5d40	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	dca62b1f-e764-4007-b9ef-b8f0e703bd00	2	20	t	18af4f01-e445-45a7-98a9-b8480a54015d	\N
c66d36e1-42ff-4c9c-af83-b35d98777174	\N	idp-username-password-form	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	18af4f01-e445-45a7-98a9-b8480a54015d	0	10	f	\N	\N
bcd71740-f276-47d1-aacd-73d639c3760d	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	18af4f01-e445-45a7-98a9-b8480a54015d	1	20	t	bc9b8394-ac12-468a-a3dc-55ec4bc3e0b2	\N
1a6da546-475f-407c-aac4-316679657dee	\N	conditional-user-configured	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	bc9b8394-ac12-468a-a3dc-55ec4bc3e0b2	0	10	f	\N	\N
9c89e2a4-4d58-4745-b407-f03339a73da7	\N	auth-otp-form	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	bc9b8394-ac12-468a-a3dc-55ec4bc3e0b2	0	20	f	\N	\N
52f9aa77-a64f-4d1f-bb30-8e7a0471f1a2	\N	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2a26e08e-2278-4d56-931b-12601113607f	1	50	t	8ee8d001-4c41-48e3-b3d7-463fd007ac2b	\N
3f279d4e-4f74-4d98-a9a2-55073fa2a9ef	\N	conditional-user-configured	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	8ee8d001-4c41-48e3-b3d7-463fd007ac2b	0	10	f	\N	\N
eb589b8a-b684-4b7a-8a45-433601b04eaa	\N	idp-add-organization-member	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	8ee8d001-4c41-48e3-b3d7-463fd007ac2b	0	20	f	\N	\N
a72c1865-01c1-481a-b7f2-00d5e6d96a35	\N	http-basic-authenticator	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	12ce7ac1-6e95-4ef2-a19f-06099f6fb78b	0	10	f	\N	\N
e2aa3c69-64be-4ada-9f7e-dbcc79ef67d2	\N	docker-http-basic-authenticator	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	478c5259-862d-4db9-a2ea-bd0887d86ee9	0	10	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
4a846dc6-2f5a-4511-be8b-7cb3b102b7b2	browser	Browser based authentication	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	basic-flow	t	t
cb87ec6f-6c80-4bf4-a473-8c5cb5a3960e	forms	Username, password, otp and other auth forms.	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	basic-flow	f	t
06d67977-b0bf-4b9a-9aef-93d0ceaf80db	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	basic-flow	f	t
bd4dfd9f-d75d-43ac-9c9f-a1d0f788dabf	direct grant	OpenID Connect Resource Owner Grant	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	basic-flow	t	t
0e6f1893-2a67-433f-812f-c8a0c2e17e44	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	basic-flow	f	t
b60df5bb-0405-4efb-bb7c-039a76420cbf	registration	Registration flow	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	basic-flow	t	t
28d003f6-46a4-42a1-a279-46ec171018ec	registration form	Registration form	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	form-flow	f	t
9718049a-8296-4ce6-a2ef-fd27474a8ff6	reset credentials	Reset credentials for a user if they forgot their password or something	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	basic-flow	t	t
f84209ea-9421-4bb5-8c01-2b2b12d7bdba	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	basic-flow	f	t
a6d113ef-e81f-42ac-b1a1-18bf9f7883f8	clients	Base authentication for clients	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	client-flow	t	t
b52bd267-b851-43a1-8a88-7fa0693f0e0c	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	basic-flow	t	t
63973eeb-2e8e-414c-bc07-3cc75b7d8d94	User creation or linking	Flow for the existing/non-existing user alternatives	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	basic-flow	f	t
5756c2f6-d8dd-4b03-8a52-f98435a425b1	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	basic-flow	f	t
504b701f-61d9-4123-9870-3cf9998f25bb	Account verification options	Method with which to verity the existing account	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	basic-flow	f	t
14dcc8bd-9012-40b4-aa73-2b1f4e8e1b37	Verify Existing Account by Re-authentication	Reauthentication of existing account	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	basic-flow	f	t
8201b84c-9740-49bb-ab6f-5aa6e62254fa	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	basic-flow	f	t
5e103801-cb04-4753-a899-57b4ace4bac6	saml ecp	SAML ECP Profile Authentication Flow	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	basic-flow	t	t
93510552-7da0-4d2f-8103-888e1c4267ac	docker auth	Used by Docker clients to authenticate against the IDP	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	basic-flow	t	t
11d4a136-08ef-4185-879e-20a7e5e71ea0	browser	Browser based authentication	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	t	t
8340e02e-4a7f-4979-b060-e62241f68034	forms	Username, password, otp and other auth forms.	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
70a17c71-1e0e-4dcf-913e-e0b929c49a33	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
e11b4410-776d-4f45-9da6-3d50fd0ecb57	Organization	\N	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
1892e93c-fde1-4fd3-b2dd-a1edd45ecd26	Browser - Conditional Organization	Flow to determine if the organization identity-first login is to be used	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
8de5f3d7-1fd9-4859-97bb-5859d47db91c	direct grant	OpenID Connect Resource Owner Grant	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	t	t
58ccdd5d-9e47-42b0-b8d7-b89a064daa69	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
58806ca6-b5ca-4f7f-9550-a8cec9066c73	registration	Registration flow	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	t	t
5f09c312-15b0-4ae2-9f37-162501b73124	registration form	Registration form	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	form-flow	f	t
1c24920f-adcf-403f-aeee-622e2218c632	reset credentials	Reset credentials for a user if they forgot their password or something	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	t	t
24080a19-f1bd-451a-bbb5-af9f3d658205	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
f7ba0e0f-7be0-458e-aae1-6e59a6b35aec	clients	Base authentication for clients	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	client-flow	t	t
2a26e08e-2278-4d56-931b-12601113607f	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	t	t
4abee144-ad13-44f6-9b23-b8b11d5e8149	User creation or linking	Flow for the existing/non-existing user alternatives	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
e156e078-07ed-4bec-ad4c-4f19508ea595	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
dca62b1f-e764-4007-b9ef-b8f0e703bd00	Account verification options	Method with which to verity the existing account	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
18af4f01-e445-45a7-98a9-b8480a54015d	Verify Existing Account by Re-authentication	Reauthentication of existing account	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
bc9b8394-ac12-468a-a3dc-55ec4bc3e0b2	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
8ee8d001-4c41-48e3-b3d7-463fd007ac2b	First Broker Login - Conditional Organization	Flow to determine if the authenticator that adds organization members is to be used	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	f	t
12ce7ac1-6e95-4ef2-a19f-06099f6fb78b	saml ecp	SAML ECP Profile Authentication Flow	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	t	t
478c5259-862d-4db9-a2ea-bd0887d86ee9	docker auth	Used by Docker clients to authenticate against the IDP	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	basic-flow	t	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
9fc515ef-265f-41cb-9162-9e9aecc68824	review profile config	9427ab20-f0da-41bd-8ffd-6c4fffb2afec
f3911a1d-e9bd-4cc6-9607-755656449ab7	create unique user config	9427ab20-f0da-41bd-8ffd-6c4fffb2afec
e91259f8-3397-41af-87d9-78354e82655d	review profile config	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc
842f0ae4-5ec3-438f-8567-714ee5373efc	create unique user config	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
9fc515ef-265f-41cb-9162-9e9aecc68824	missing	update.profile.on.first.login
f3911a1d-e9bd-4cc6-9607-755656449ab7	false	require.password.update.after.registration
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
2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	t	f	master-realm	0	f	\N	\N	t	\N	f	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
ac19a97d-4491-41af-821a-8ed32e659238	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
d71f7760-85bc-44da-bf2b-7f44d17e580b	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
04149cb0-f7b0-43c2-b5d6-c2ec965fd2d8	t	f	broker	0	f	\N	\N	t	\N	f	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
bd065e4a-130c-45f2-8c11-674e99fb51fb	t	t	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
162fa6f3-0d04-4439-a8ce-736affc20efa	t	t	admin-cli	0	t	\N	\N	f	\N	f	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
20a6e660-7f69-4043-a157-2d2f03b71f01	t	f	nextjs-dashboard-realm	0	f	\N	\N	t	\N	f	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	\N	0	f	f	nextjs-dashboard Realm	f	client-secret	\N	\N	\N	t	f	f	f
2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	f	realm-management	0	f	\N	\N	t	\N	f	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	t	f	account	0	t	\N	/realms/nextjs-dashboard/account/	f	\N	f	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
6594bd92-c078-437d-aa19-32810411fe71	t	f	account-console	0	t	\N	/realms/nextjs-dashboard/account/	f	\N	f	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
ea8fbaa3-b5f1-4548-acef-7f4622c53980	t	f	broker	0	f	\N	\N	t	\N	f	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
b323fd36-7155-40a7-9eb1-94d315656e84	t	t	security-admin-console	0	t	\N	/admin/nextjs-dashboard/console/	f	\N	f	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	t	t	admin-cli	0	t	\N	\N	f	\N	f	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	t	t	parkigo	0	f	EizZfQy12vFin9Nzty0ro6tGQockUbBl	\N	f	http://localhost:3000	f	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	openid-connect	-1	f	f	\N	f	client-secret	http://localhost:3000	\N	\N	t	f	t	f
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.client_attributes (client_id, name, value) FROM stdin;
ac19a97d-4491-41af-821a-8ed32e659238	post.logout.redirect.uris	+
d71f7760-85bc-44da-bf2b-7f44d17e580b	post.logout.redirect.uris	+
d71f7760-85bc-44da-bf2b-7f44d17e580b	pkce.code.challenge.method	S256
bd065e4a-130c-45f2-8c11-674e99fb51fb	post.logout.redirect.uris	+
bd065e4a-130c-45f2-8c11-674e99fb51fb	pkce.code.challenge.method	S256
bd065e4a-130c-45f2-8c11-674e99fb51fb	client.use.lightweight.access.token.enabled	true
162fa6f3-0d04-4439-a8ce-736affc20efa	client.use.lightweight.access.token.enabled	true
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	post.logout.redirect.uris	+
6594bd92-c078-437d-aa19-32810411fe71	post.logout.redirect.uris	+
6594bd92-c078-437d-aa19-32810411fe71	pkce.code.challenge.method	S256
b323fd36-7155-40a7-9eb1-94d315656e84	post.logout.redirect.uris	+
b323fd36-7155-40a7-9eb1-94d315656e84	pkce.code.challenge.method	S256
b323fd36-7155-40a7-9eb1-94d315656e84	client.use.lightweight.access.token.enabled	true
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	client.use.lightweight.access.token.enabled	true
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	post.logout.redirect.uris	+
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
1b8b33fa-d3e9-4ce6-a388-6abc010589e9	offline_access	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	OpenID Connect built-in scope: offline_access	openid-connect
b648708b-4045-4cf5-9bc2-3e4b2936100f	role_list	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	SAML role list	saml
049a264b-466a-45dc-b92f-df53fbc6192c	saml_organization	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	Organization Membership	saml
6bc23c09-d36b-4291-b1dc-4d1a46fbbb72	profile	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	OpenID Connect built-in scope: profile	openid-connect
73c1a3d6-4422-4ffc-8e90-9ebf10d8de52	email	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	OpenID Connect built-in scope: email	openid-connect
c1e8b245-1801-4f18-bcd6-d0134ca5ff5f	address	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	OpenID Connect built-in scope: address	openid-connect
c72c3f5e-4bd5-47e0-aa95-7965f2aa68ba	phone	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	OpenID Connect built-in scope: phone	openid-connect
083216b5-3aca-4685-b461-e835aff2acd7	roles	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	OpenID Connect scope for add user roles to the access token	openid-connect
1b558ef7-32d7-4df6-af3f-25ca4089b195	web-origins	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	OpenID Connect scope for add allowed web origins to the access token	openid-connect
d7d2f37c-0430-498e-9f5f-91135e10d64e	microprofile-jwt	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	Microprofile - JWT built-in scope	openid-connect
52c17ef6-dd48-457f-b27d-047c0bb84708	acr	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
02ceb4d8-fe1c-423a-903f-5e4fa5bd2d6d	basic	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	OpenID Connect scope for add all basic claims to the token	openid-connect
ac769c39-1b97-45b7-8d94-42982e123337	service_account	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	Specific scope for a client enabled for service accounts	openid-connect
d0179dba-d8ad-4d2a-9231-075f2e6530c8	organization	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	Additional claims about the organization a subject belongs to	openid-connect
34aa2dce-16c8-457d-9178-bb836e027ca2	offline_access	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	OpenID Connect built-in scope: offline_access	openid-connect
2977881a-44c7-40ba-aa11-afb0a05ec0b2	role_list	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	SAML role list	saml
8c468075-525e-4ab3-94ec-ba4dc437c24f	saml_organization	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	Organization Membership	saml
178dac49-f258-4a20-a227-baca55f97d8d	profile	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	OpenID Connect built-in scope: profile	openid-connect
b9c6ce23-7173-41dd-be46-cdfb74fec18a	email	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	OpenID Connect built-in scope: email	openid-connect
1ed0d4c4-0720-4e69-be21-091241d3c574	address	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	OpenID Connect built-in scope: address	openid-connect
49ab1a06-38f4-4c32-868e-48b61022c00f	phone	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	OpenID Connect built-in scope: phone	openid-connect
5b0a8700-85e8-46b9-a764-6cd2f85d8846	roles	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	OpenID Connect scope for add user roles to the access token	openid-connect
ef14b883-04bf-4557-be1a-231b99162857	web-origins	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	OpenID Connect scope for add allowed web origins to the access token	openid-connect
813c8c55-74e0-494f-9682-23d026340f42	microprofile-jwt	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	Microprofile - JWT built-in scope	openid-connect
fa609b0e-925f-4251-a437-291fdf9d71a1	acr	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
51061315-4b70-49de-b605-55a40d6ab93f	basic	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	OpenID Connect scope for add all basic claims to the token	openid-connect
c6917b9d-3aae-48d7-887d-9d1f1c3c50a0	service_account	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	Specific scope for a client enabled for service accounts	openid-connect
411c662c-cd97-4f46-a8bc-7a4f473f7cfb	organization	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	Additional claims about the organization a subject belongs to	openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
1b8b33fa-d3e9-4ce6-a388-6abc010589e9	true	display.on.consent.screen
1b8b33fa-d3e9-4ce6-a388-6abc010589e9	${offlineAccessScopeConsentText}	consent.screen.text
b648708b-4045-4cf5-9bc2-3e4b2936100f	true	display.on.consent.screen
b648708b-4045-4cf5-9bc2-3e4b2936100f	${samlRoleListScopeConsentText}	consent.screen.text
049a264b-466a-45dc-b92f-df53fbc6192c	false	display.on.consent.screen
6bc23c09-d36b-4291-b1dc-4d1a46fbbb72	true	display.on.consent.screen
6bc23c09-d36b-4291-b1dc-4d1a46fbbb72	${profileScopeConsentText}	consent.screen.text
6bc23c09-d36b-4291-b1dc-4d1a46fbbb72	true	include.in.token.scope
73c1a3d6-4422-4ffc-8e90-9ebf10d8de52	true	display.on.consent.screen
73c1a3d6-4422-4ffc-8e90-9ebf10d8de52	${emailScopeConsentText}	consent.screen.text
73c1a3d6-4422-4ffc-8e90-9ebf10d8de52	true	include.in.token.scope
c1e8b245-1801-4f18-bcd6-d0134ca5ff5f	true	display.on.consent.screen
c1e8b245-1801-4f18-bcd6-d0134ca5ff5f	${addressScopeConsentText}	consent.screen.text
c1e8b245-1801-4f18-bcd6-d0134ca5ff5f	true	include.in.token.scope
c72c3f5e-4bd5-47e0-aa95-7965f2aa68ba	true	display.on.consent.screen
c72c3f5e-4bd5-47e0-aa95-7965f2aa68ba	${phoneScopeConsentText}	consent.screen.text
c72c3f5e-4bd5-47e0-aa95-7965f2aa68ba	true	include.in.token.scope
083216b5-3aca-4685-b461-e835aff2acd7	true	display.on.consent.screen
083216b5-3aca-4685-b461-e835aff2acd7	${rolesScopeConsentText}	consent.screen.text
083216b5-3aca-4685-b461-e835aff2acd7	false	include.in.token.scope
1b558ef7-32d7-4df6-af3f-25ca4089b195	false	display.on.consent.screen
1b558ef7-32d7-4df6-af3f-25ca4089b195		consent.screen.text
1b558ef7-32d7-4df6-af3f-25ca4089b195	false	include.in.token.scope
d7d2f37c-0430-498e-9f5f-91135e10d64e	false	display.on.consent.screen
d7d2f37c-0430-498e-9f5f-91135e10d64e	true	include.in.token.scope
52c17ef6-dd48-457f-b27d-047c0bb84708	false	display.on.consent.screen
52c17ef6-dd48-457f-b27d-047c0bb84708	false	include.in.token.scope
02ceb4d8-fe1c-423a-903f-5e4fa5bd2d6d	false	display.on.consent.screen
02ceb4d8-fe1c-423a-903f-5e4fa5bd2d6d	false	include.in.token.scope
ac769c39-1b97-45b7-8d94-42982e123337	false	display.on.consent.screen
ac769c39-1b97-45b7-8d94-42982e123337	false	include.in.token.scope
d0179dba-d8ad-4d2a-9231-075f2e6530c8	true	display.on.consent.screen
d0179dba-d8ad-4d2a-9231-075f2e6530c8	${organizationScopeConsentText}	consent.screen.text
d0179dba-d8ad-4d2a-9231-075f2e6530c8	true	include.in.token.scope
34aa2dce-16c8-457d-9178-bb836e027ca2	true	display.on.consent.screen
34aa2dce-16c8-457d-9178-bb836e027ca2	${offlineAccessScopeConsentText}	consent.screen.text
2977881a-44c7-40ba-aa11-afb0a05ec0b2	true	display.on.consent.screen
2977881a-44c7-40ba-aa11-afb0a05ec0b2	${samlRoleListScopeConsentText}	consent.screen.text
8c468075-525e-4ab3-94ec-ba4dc437c24f	false	display.on.consent.screen
178dac49-f258-4a20-a227-baca55f97d8d	true	display.on.consent.screen
178dac49-f258-4a20-a227-baca55f97d8d	${profileScopeConsentText}	consent.screen.text
178dac49-f258-4a20-a227-baca55f97d8d	true	include.in.token.scope
b9c6ce23-7173-41dd-be46-cdfb74fec18a	true	display.on.consent.screen
b9c6ce23-7173-41dd-be46-cdfb74fec18a	${emailScopeConsentText}	consent.screen.text
b9c6ce23-7173-41dd-be46-cdfb74fec18a	true	include.in.token.scope
1ed0d4c4-0720-4e69-be21-091241d3c574	true	display.on.consent.screen
1ed0d4c4-0720-4e69-be21-091241d3c574	${addressScopeConsentText}	consent.screen.text
1ed0d4c4-0720-4e69-be21-091241d3c574	true	include.in.token.scope
49ab1a06-38f4-4c32-868e-48b61022c00f	true	display.on.consent.screen
49ab1a06-38f4-4c32-868e-48b61022c00f	${phoneScopeConsentText}	consent.screen.text
49ab1a06-38f4-4c32-868e-48b61022c00f	true	include.in.token.scope
5b0a8700-85e8-46b9-a764-6cd2f85d8846	true	display.on.consent.screen
5b0a8700-85e8-46b9-a764-6cd2f85d8846	${rolesScopeConsentText}	consent.screen.text
5b0a8700-85e8-46b9-a764-6cd2f85d8846	false	include.in.token.scope
ef14b883-04bf-4557-be1a-231b99162857	false	display.on.consent.screen
ef14b883-04bf-4557-be1a-231b99162857		consent.screen.text
ef14b883-04bf-4557-be1a-231b99162857	false	include.in.token.scope
813c8c55-74e0-494f-9682-23d026340f42	false	display.on.consent.screen
813c8c55-74e0-494f-9682-23d026340f42	true	include.in.token.scope
fa609b0e-925f-4251-a437-291fdf9d71a1	false	display.on.consent.screen
fa609b0e-925f-4251-a437-291fdf9d71a1	false	include.in.token.scope
51061315-4b70-49de-b605-55a40d6ab93f	false	display.on.consent.screen
51061315-4b70-49de-b605-55a40d6ab93f	false	include.in.token.scope
c6917b9d-3aae-48d7-887d-9d1f1c3c50a0	false	display.on.consent.screen
c6917b9d-3aae-48d7-887d-9d1f1c3c50a0	false	include.in.token.scope
411c662c-cd97-4f46-a8bc-7a4f473f7cfb	true	display.on.consent.screen
411c662c-cd97-4f46-a8bc-7a4f473f7cfb	${organizationScopeConsentText}	consent.screen.text
411c662c-cd97-4f46-a8bc-7a4f473f7cfb	true	include.in.token.scope
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
ac19a97d-4491-41af-821a-8ed32e659238	02ceb4d8-fe1c-423a-903f-5e4fa5bd2d6d	t
ac19a97d-4491-41af-821a-8ed32e659238	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72	t
ac19a97d-4491-41af-821a-8ed32e659238	1b558ef7-32d7-4df6-af3f-25ca4089b195	t
ac19a97d-4491-41af-821a-8ed32e659238	73c1a3d6-4422-4ffc-8e90-9ebf10d8de52	t
ac19a97d-4491-41af-821a-8ed32e659238	52c17ef6-dd48-457f-b27d-047c0bb84708	t
ac19a97d-4491-41af-821a-8ed32e659238	083216b5-3aca-4685-b461-e835aff2acd7	t
ac19a97d-4491-41af-821a-8ed32e659238	d7d2f37c-0430-498e-9f5f-91135e10d64e	f
ac19a97d-4491-41af-821a-8ed32e659238	d0179dba-d8ad-4d2a-9231-075f2e6530c8	f
ac19a97d-4491-41af-821a-8ed32e659238	1b8b33fa-d3e9-4ce6-a388-6abc010589e9	f
ac19a97d-4491-41af-821a-8ed32e659238	c1e8b245-1801-4f18-bcd6-d0134ca5ff5f	f
ac19a97d-4491-41af-821a-8ed32e659238	c72c3f5e-4bd5-47e0-aa95-7965f2aa68ba	f
d71f7760-85bc-44da-bf2b-7f44d17e580b	02ceb4d8-fe1c-423a-903f-5e4fa5bd2d6d	t
d71f7760-85bc-44da-bf2b-7f44d17e580b	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72	t
d71f7760-85bc-44da-bf2b-7f44d17e580b	1b558ef7-32d7-4df6-af3f-25ca4089b195	t
d71f7760-85bc-44da-bf2b-7f44d17e580b	73c1a3d6-4422-4ffc-8e90-9ebf10d8de52	t
d71f7760-85bc-44da-bf2b-7f44d17e580b	52c17ef6-dd48-457f-b27d-047c0bb84708	t
d71f7760-85bc-44da-bf2b-7f44d17e580b	083216b5-3aca-4685-b461-e835aff2acd7	t
d71f7760-85bc-44da-bf2b-7f44d17e580b	d7d2f37c-0430-498e-9f5f-91135e10d64e	f
d71f7760-85bc-44da-bf2b-7f44d17e580b	d0179dba-d8ad-4d2a-9231-075f2e6530c8	f
d71f7760-85bc-44da-bf2b-7f44d17e580b	1b8b33fa-d3e9-4ce6-a388-6abc010589e9	f
d71f7760-85bc-44da-bf2b-7f44d17e580b	c1e8b245-1801-4f18-bcd6-d0134ca5ff5f	f
d71f7760-85bc-44da-bf2b-7f44d17e580b	c72c3f5e-4bd5-47e0-aa95-7965f2aa68ba	f
162fa6f3-0d04-4439-a8ce-736affc20efa	02ceb4d8-fe1c-423a-903f-5e4fa5bd2d6d	t
162fa6f3-0d04-4439-a8ce-736affc20efa	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72	t
162fa6f3-0d04-4439-a8ce-736affc20efa	1b558ef7-32d7-4df6-af3f-25ca4089b195	t
162fa6f3-0d04-4439-a8ce-736affc20efa	73c1a3d6-4422-4ffc-8e90-9ebf10d8de52	t
162fa6f3-0d04-4439-a8ce-736affc20efa	52c17ef6-dd48-457f-b27d-047c0bb84708	t
162fa6f3-0d04-4439-a8ce-736affc20efa	083216b5-3aca-4685-b461-e835aff2acd7	t
162fa6f3-0d04-4439-a8ce-736affc20efa	d7d2f37c-0430-498e-9f5f-91135e10d64e	f
162fa6f3-0d04-4439-a8ce-736affc20efa	d0179dba-d8ad-4d2a-9231-075f2e6530c8	f
162fa6f3-0d04-4439-a8ce-736affc20efa	1b8b33fa-d3e9-4ce6-a388-6abc010589e9	f
162fa6f3-0d04-4439-a8ce-736affc20efa	c1e8b245-1801-4f18-bcd6-d0134ca5ff5f	f
162fa6f3-0d04-4439-a8ce-736affc20efa	c72c3f5e-4bd5-47e0-aa95-7965f2aa68ba	f
04149cb0-f7b0-43c2-b5d6-c2ec965fd2d8	02ceb4d8-fe1c-423a-903f-5e4fa5bd2d6d	t
04149cb0-f7b0-43c2-b5d6-c2ec965fd2d8	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72	t
04149cb0-f7b0-43c2-b5d6-c2ec965fd2d8	1b558ef7-32d7-4df6-af3f-25ca4089b195	t
04149cb0-f7b0-43c2-b5d6-c2ec965fd2d8	73c1a3d6-4422-4ffc-8e90-9ebf10d8de52	t
04149cb0-f7b0-43c2-b5d6-c2ec965fd2d8	52c17ef6-dd48-457f-b27d-047c0bb84708	t
04149cb0-f7b0-43c2-b5d6-c2ec965fd2d8	083216b5-3aca-4685-b461-e835aff2acd7	t
04149cb0-f7b0-43c2-b5d6-c2ec965fd2d8	d7d2f37c-0430-498e-9f5f-91135e10d64e	f
04149cb0-f7b0-43c2-b5d6-c2ec965fd2d8	d0179dba-d8ad-4d2a-9231-075f2e6530c8	f
04149cb0-f7b0-43c2-b5d6-c2ec965fd2d8	1b8b33fa-d3e9-4ce6-a388-6abc010589e9	f
04149cb0-f7b0-43c2-b5d6-c2ec965fd2d8	c1e8b245-1801-4f18-bcd6-d0134ca5ff5f	f
04149cb0-f7b0-43c2-b5d6-c2ec965fd2d8	c72c3f5e-4bd5-47e0-aa95-7965f2aa68ba	f
2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	02ceb4d8-fe1c-423a-903f-5e4fa5bd2d6d	t
2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72	t
2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	1b558ef7-32d7-4df6-af3f-25ca4089b195	t
2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	73c1a3d6-4422-4ffc-8e90-9ebf10d8de52	t
2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	52c17ef6-dd48-457f-b27d-047c0bb84708	t
2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	083216b5-3aca-4685-b461-e835aff2acd7	t
2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	d7d2f37c-0430-498e-9f5f-91135e10d64e	f
2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	d0179dba-d8ad-4d2a-9231-075f2e6530c8	f
2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	1b8b33fa-d3e9-4ce6-a388-6abc010589e9	f
2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	c1e8b245-1801-4f18-bcd6-d0134ca5ff5f	f
2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	c72c3f5e-4bd5-47e0-aa95-7965f2aa68ba	f
bd065e4a-130c-45f2-8c11-674e99fb51fb	02ceb4d8-fe1c-423a-903f-5e4fa5bd2d6d	t
bd065e4a-130c-45f2-8c11-674e99fb51fb	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72	t
bd065e4a-130c-45f2-8c11-674e99fb51fb	1b558ef7-32d7-4df6-af3f-25ca4089b195	t
bd065e4a-130c-45f2-8c11-674e99fb51fb	73c1a3d6-4422-4ffc-8e90-9ebf10d8de52	t
bd065e4a-130c-45f2-8c11-674e99fb51fb	52c17ef6-dd48-457f-b27d-047c0bb84708	t
bd065e4a-130c-45f2-8c11-674e99fb51fb	083216b5-3aca-4685-b461-e835aff2acd7	t
bd065e4a-130c-45f2-8c11-674e99fb51fb	d7d2f37c-0430-498e-9f5f-91135e10d64e	f
bd065e4a-130c-45f2-8c11-674e99fb51fb	d0179dba-d8ad-4d2a-9231-075f2e6530c8	f
bd065e4a-130c-45f2-8c11-674e99fb51fb	1b8b33fa-d3e9-4ce6-a388-6abc010589e9	f
bd065e4a-130c-45f2-8c11-674e99fb51fb	c1e8b245-1801-4f18-bcd6-d0134ca5ff5f	f
bd065e4a-130c-45f2-8c11-674e99fb51fb	c72c3f5e-4bd5-47e0-aa95-7965f2aa68ba	f
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	b9c6ce23-7173-41dd-be46-cdfb74fec18a	t
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	fa609b0e-925f-4251-a437-291fdf9d71a1	t
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	5b0a8700-85e8-46b9-a764-6cd2f85d8846	t
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	ef14b883-04bf-4557-be1a-231b99162857	t
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	178dac49-f258-4a20-a227-baca55f97d8d	t
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	51061315-4b70-49de-b605-55a40d6ab93f	t
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	1ed0d4c4-0720-4e69-be21-091241d3c574	f
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	411c662c-cd97-4f46-a8bc-7a4f473f7cfb	f
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	34aa2dce-16c8-457d-9178-bb836e027ca2	f
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	49ab1a06-38f4-4c32-868e-48b61022c00f	f
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	813c8c55-74e0-494f-9682-23d026340f42	f
6594bd92-c078-437d-aa19-32810411fe71	b9c6ce23-7173-41dd-be46-cdfb74fec18a	t
6594bd92-c078-437d-aa19-32810411fe71	fa609b0e-925f-4251-a437-291fdf9d71a1	t
6594bd92-c078-437d-aa19-32810411fe71	5b0a8700-85e8-46b9-a764-6cd2f85d8846	t
6594bd92-c078-437d-aa19-32810411fe71	ef14b883-04bf-4557-be1a-231b99162857	t
6594bd92-c078-437d-aa19-32810411fe71	178dac49-f258-4a20-a227-baca55f97d8d	t
6594bd92-c078-437d-aa19-32810411fe71	51061315-4b70-49de-b605-55a40d6ab93f	t
6594bd92-c078-437d-aa19-32810411fe71	1ed0d4c4-0720-4e69-be21-091241d3c574	f
6594bd92-c078-437d-aa19-32810411fe71	411c662c-cd97-4f46-a8bc-7a4f473f7cfb	f
6594bd92-c078-437d-aa19-32810411fe71	34aa2dce-16c8-457d-9178-bb836e027ca2	f
6594bd92-c078-437d-aa19-32810411fe71	49ab1a06-38f4-4c32-868e-48b61022c00f	f
6594bd92-c078-437d-aa19-32810411fe71	813c8c55-74e0-494f-9682-23d026340f42	f
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	b9c6ce23-7173-41dd-be46-cdfb74fec18a	t
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	fa609b0e-925f-4251-a437-291fdf9d71a1	t
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	5b0a8700-85e8-46b9-a764-6cd2f85d8846	t
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	ef14b883-04bf-4557-be1a-231b99162857	t
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	178dac49-f258-4a20-a227-baca55f97d8d	t
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	51061315-4b70-49de-b605-55a40d6ab93f	t
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	1ed0d4c4-0720-4e69-be21-091241d3c574	f
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	411c662c-cd97-4f46-a8bc-7a4f473f7cfb	f
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	34aa2dce-16c8-457d-9178-bb836e027ca2	f
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	49ab1a06-38f4-4c32-868e-48b61022c00f	f
ff8ef64a-d30c-4b76-988a-d1dcdb3362ff	813c8c55-74e0-494f-9682-23d026340f42	f
ea8fbaa3-b5f1-4548-acef-7f4622c53980	b9c6ce23-7173-41dd-be46-cdfb74fec18a	t
ea8fbaa3-b5f1-4548-acef-7f4622c53980	fa609b0e-925f-4251-a437-291fdf9d71a1	t
ea8fbaa3-b5f1-4548-acef-7f4622c53980	5b0a8700-85e8-46b9-a764-6cd2f85d8846	t
ea8fbaa3-b5f1-4548-acef-7f4622c53980	ef14b883-04bf-4557-be1a-231b99162857	t
ea8fbaa3-b5f1-4548-acef-7f4622c53980	178dac49-f258-4a20-a227-baca55f97d8d	t
ea8fbaa3-b5f1-4548-acef-7f4622c53980	51061315-4b70-49de-b605-55a40d6ab93f	t
ea8fbaa3-b5f1-4548-acef-7f4622c53980	1ed0d4c4-0720-4e69-be21-091241d3c574	f
ea8fbaa3-b5f1-4548-acef-7f4622c53980	411c662c-cd97-4f46-a8bc-7a4f473f7cfb	f
ea8fbaa3-b5f1-4548-acef-7f4622c53980	34aa2dce-16c8-457d-9178-bb836e027ca2	f
ea8fbaa3-b5f1-4548-acef-7f4622c53980	49ab1a06-38f4-4c32-868e-48b61022c00f	f
ea8fbaa3-b5f1-4548-acef-7f4622c53980	813c8c55-74e0-494f-9682-23d026340f42	f
2aceca6f-245d-4ffe-80a0-efc46198a4f2	b9c6ce23-7173-41dd-be46-cdfb74fec18a	t
2aceca6f-245d-4ffe-80a0-efc46198a4f2	fa609b0e-925f-4251-a437-291fdf9d71a1	t
2aceca6f-245d-4ffe-80a0-efc46198a4f2	5b0a8700-85e8-46b9-a764-6cd2f85d8846	t
2aceca6f-245d-4ffe-80a0-efc46198a4f2	ef14b883-04bf-4557-be1a-231b99162857	t
2aceca6f-245d-4ffe-80a0-efc46198a4f2	178dac49-f258-4a20-a227-baca55f97d8d	t
2aceca6f-245d-4ffe-80a0-efc46198a4f2	51061315-4b70-49de-b605-55a40d6ab93f	t
2aceca6f-245d-4ffe-80a0-efc46198a4f2	1ed0d4c4-0720-4e69-be21-091241d3c574	f
2aceca6f-245d-4ffe-80a0-efc46198a4f2	411c662c-cd97-4f46-a8bc-7a4f473f7cfb	f
2aceca6f-245d-4ffe-80a0-efc46198a4f2	34aa2dce-16c8-457d-9178-bb836e027ca2	f
2aceca6f-245d-4ffe-80a0-efc46198a4f2	49ab1a06-38f4-4c32-868e-48b61022c00f	f
2aceca6f-245d-4ffe-80a0-efc46198a4f2	813c8c55-74e0-494f-9682-23d026340f42	f
b323fd36-7155-40a7-9eb1-94d315656e84	b9c6ce23-7173-41dd-be46-cdfb74fec18a	t
b323fd36-7155-40a7-9eb1-94d315656e84	fa609b0e-925f-4251-a437-291fdf9d71a1	t
b323fd36-7155-40a7-9eb1-94d315656e84	5b0a8700-85e8-46b9-a764-6cd2f85d8846	t
b323fd36-7155-40a7-9eb1-94d315656e84	ef14b883-04bf-4557-be1a-231b99162857	t
b323fd36-7155-40a7-9eb1-94d315656e84	178dac49-f258-4a20-a227-baca55f97d8d	t
b323fd36-7155-40a7-9eb1-94d315656e84	51061315-4b70-49de-b605-55a40d6ab93f	t
b323fd36-7155-40a7-9eb1-94d315656e84	1ed0d4c4-0720-4e69-be21-091241d3c574	f
b323fd36-7155-40a7-9eb1-94d315656e84	411c662c-cd97-4f46-a8bc-7a4f473f7cfb	f
b323fd36-7155-40a7-9eb1-94d315656e84	34aa2dce-16c8-457d-9178-bb836e027ca2	f
b323fd36-7155-40a7-9eb1-94d315656e84	49ab1a06-38f4-4c32-868e-48b61022c00f	f
b323fd36-7155-40a7-9eb1-94d315656e84	813c8c55-74e0-494f-9682-23d026340f42	f
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	b9c6ce23-7173-41dd-be46-cdfb74fec18a	t
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	fa609b0e-925f-4251-a437-291fdf9d71a1	t
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	5b0a8700-85e8-46b9-a764-6cd2f85d8846	t
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	ef14b883-04bf-4557-be1a-231b99162857	t
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	178dac49-f258-4a20-a227-baca55f97d8d	t
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	51061315-4b70-49de-b605-55a40d6ab93f	t
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	1ed0d4c4-0720-4e69-be21-091241d3c574	f
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	411c662c-cd97-4f46-a8bc-7a4f473f7cfb	f
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	34aa2dce-16c8-457d-9178-bb836e027ca2	f
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	49ab1a06-38f4-4c32-868e-48b61022c00f	f
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	813c8c55-74e0-494f-9682-23d026340f42	f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
1b8b33fa-d3e9-4ce6-a388-6abc010589e9	eaae3760-7633-468b-aa11-def248b30acb
34aa2dce-16c8-457d-9178-bb836e027ca2	5926e4b6-ce4f-44c7-b71f-3ec7ffb9cdd6
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
704853e2-50d5-4e5a-ba27-2b5c74a03a30	Trusted Hosts	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	anonymous
92a6eded-7177-498a-be0c-193b423101ed	Consent Required	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	anonymous
707d1987-9a9e-410e-892b-6031d535586c	Full Scope Disabled	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	anonymous
785ea558-faa2-4191-b8fd-e44f877a6bf6	Max Clients Limit	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	anonymous
7b2c5bea-0d28-43e3-b1fb-8c8ab50cb025	Allowed Protocol Mapper Types	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	anonymous
4dd09893-6a72-4975-b19a-7b84ea877c5f	Allowed Client Scopes	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	anonymous
d6a8bde4-2751-4bea-b966-1e4466f0f590	Allowed Protocol Mapper Types	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	authenticated
218c6ac4-fc20-4464-a10e-7064c6ace18f	Allowed Client Scopes	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	authenticated
1253a969-8ef4-46c3-9d37-a3696b94cb78	rsa-generated	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	rsa-generated	org.keycloak.keys.KeyProvider	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	\N
047e858b-661c-48f9-a2ed-8b4a3ab25ec7	rsa-enc-generated	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	rsa-enc-generated	org.keycloak.keys.KeyProvider	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	\N
a089809d-98d9-4167-b5f5-a163e1fe0637	hmac-generated-hs512	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	hmac-generated	org.keycloak.keys.KeyProvider	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	\N
73669e4e-40ed-4004-9bbb-b20ab2e0c0de	aes-generated	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	aes-generated	org.keycloak.keys.KeyProvider	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	\N
0795d36a-9bca-467d-8392-300e167b80c3	\N	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	declarative-user-profile	org.keycloak.userprofile.UserProfileProvider	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	\N
efed6c49-d4cc-49ec-bb30-6df3ce164dfe	rsa-generated	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	rsa-generated	org.keycloak.keys.KeyProvider	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	\N
71f205f1-9661-4758-91f7-f6ecf7d1631c	rsa-enc-generated	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	rsa-enc-generated	org.keycloak.keys.KeyProvider	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	\N
af488bd5-4ba4-4d10-9f0d-4a4da0e511f1	hmac-generated-hs512	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	hmac-generated	org.keycloak.keys.KeyProvider	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	\N
5489f72b-e1c1-40ed-8860-68a1892a33ae	aes-generated	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	aes-generated	org.keycloak.keys.KeyProvider	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	\N
b71bf5a6-37ea-4c32-822f-de4797bb074a	Trusted Hosts	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	anonymous
76267d78-0168-4bda-9714-cfe0abd50ab6	Consent Required	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	anonymous
535cae0d-8bf6-4635-98a3-b48d0cb9bff2	Full Scope Disabled	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	anonymous
164683a5-7f15-484f-828a-3bdcfcee8f8c	Max Clients Limit	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	anonymous
2c981e81-9e87-4554-b03c-6fdbf1694394	Allowed Protocol Mapper Types	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	anonymous
433d2e7e-ee04-4530-9555-76d4f0ac6c9f	Allowed Client Scopes	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	anonymous
586f8092-e1eb-4f53-adb0-13ae57fd9c9e	Allowed Protocol Mapper Types	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	authenticated
bf606f65-9004-466b-9d40-a6b50b2bd640	Allowed Client Scopes	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	authenticated
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
91505ec6-7ec0-44fb-87aa-257723ad11d1	218c6ac4-fc20-4464-a10e-7064c6ace18f	allow-default-scopes	true
f773f534-344d-48fb-a7ab-83185d3c5638	704853e2-50d5-4e5a-ba27-2b5c74a03a30	host-sending-registration-request-must-match	true
2fbe6ccb-93c1-4c79-af8a-f4b1b137f9c7	704853e2-50d5-4e5a-ba27-2b5c74a03a30	client-uris-must-match	true
4164d632-5850-4466-ba43-eb88f264a54c	785ea558-faa2-4191-b8fd-e44f877a6bf6	max-clients	200
0585b2e9-c27c-4a98-9c8a-c8fa682413b0	d6a8bde4-2751-4bea-b966-1e4466f0f590	allowed-protocol-mapper-types	saml-role-list-mapper
e8ebbf70-d620-4ea2-933a-7d4af567760a	d6a8bde4-2751-4bea-b966-1e4466f0f590	allowed-protocol-mapper-types	oidc-address-mapper
0be3f419-ed45-4f82-bfa6-b609faf2a4cf	d6a8bde4-2751-4bea-b966-1e4466f0f590	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
ab87d6f4-13ba-4b93-a7ff-3a17e83e080f	d6a8bde4-2751-4bea-b966-1e4466f0f590	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
09fb9384-371d-4e1a-96bc-97bf3612d196	d6a8bde4-2751-4bea-b966-1e4466f0f590	allowed-protocol-mapper-types	saml-user-attribute-mapper
bdfb45e9-78b4-4842-a419-7914a1e878b5	d6a8bde4-2751-4bea-b966-1e4466f0f590	allowed-protocol-mapper-types	oidc-full-name-mapper
31ef5101-dd9a-46b0-8292-582d56e11cd2	d6a8bde4-2751-4bea-b966-1e4466f0f590	allowed-protocol-mapper-types	saml-user-property-mapper
4bf33193-aa1a-40f4-abb7-f2446f2ddceb	d6a8bde4-2751-4bea-b966-1e4466f0f590	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
c8069665-dfff-43d8-bb50-2af2ba781363	7b2c5bea-0d28-43e3-b1fb-8c8ab50cb025	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
acd09637-fffb-40ed-b5f3-b4b299b28f7c	7b2c5bea-0d28-43e3-b1fb-8c8ab50cb025	allowed-protocol-mapper-types	oidc-full-name-mapper
804144f8-ab5c-4c45-9655-e4af8f3f24a9	7b2c5bea-0d28-43e3-b1fb-8c8ab50cb025	allowed-protocol-mapper-types	oidc-address-mapper
25516e39-095c-4d86-8590-773de9496bb4	7b2c5bea-0d28-43e3-b1fb-8c8ab50cb025	allowed-protocol-mapper-types	saml-user-property-mapper
c85662ab-7580-4802-9063-4e57948a70e0	7b2c5bea-0d28-43e3-b1fb-8c8ab50cb025	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
669f29ce-7fcf-4f8b-b136-7e6d8197d70a	7b2c5bea-0d28-43e3-b1fb-8c8ab50cb025	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
cf02de7f-4e09-451a-83b5-87506333ae07	7b2c5bea-0d28-43e3-b1fb-8c8ab50cb025	allowed-protocol-mapper-types	saml-role-list-mapper
f4410c82-ea07-46a4-a5c9-2fea4a2de86c	7b2c5bea-0d28-43e3-b1fb-8c8ab50cb025	allowed-protocol-mapper-types	saml-user-attribute-mapper
70124716-1e9e-4d9f-bf36-d6e7bd780345	4dd09893-6a72-4975-b19a-7b84ea877c5f	allow-default-scopes	true
832604af-fe05-467a-9cba-162b41663ce3	73669e4e-40ed-4004-9bbb-b20ab2e0c0de	secret	DqBYWarzFx9gZF653xOCHw
a39a2b9d-74e1-4834-9ef2-d9d614c0aa98	73669e4e-40ed-4004-9bbb-b20ab2e0c0de	priority	100
77986882-6c7f-436b-9747-05de6c14fbdd	73669e4e-40ed-4004-9bbb-b20ab2e0c0de	kid	d79a0f76-40a1-4b2b-b82a-04747f8e84c9
ab554de1-1697-4a32-a70e-24dfa2d8f30e	047e858b-661c-48f9-a2ed-8b4a3ab25ec7	algorithm	RSA-OAEP
82f92c5d-6ee2-4134-b56d-b8aa56b43ced	047e858b-661c-48f9-a2ed-8b4a3ab25ec7	priority	100
fef6e3e2-cac3-46e5-9ed6-d91e40e9b0b1	047e858b-661c-48f9-a2ed-8b4a3ab25ec7	certificate	MIICmzCCAYMCBgGXorkp7jANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjUwNjI0MTYxMzUzWhcNMzUwNjI0MTYxNTMzWjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDElY6F/gffj88azwYFU3CArkGBAPIIDxfmZSAco3BvI9oKReY81qWRpy9PtH3nSPIokjG6Mnr0g8HAjFFLXn2N7uYbGejVBSFi8Os549AYtVTEjLOwmpOHzQT80oNBEVkWpcL86vem7bT/d13Gndac+yGnKP+zSJJizaJRw1k1JUFosceWG2MPoUTOlNLXp8ULUdYEP1wQovpFLuhoFg3EiA1pSsddtP5ClSRNjv6TJs7U0ZtkbTTYTNidr0netyzVSzD9jmDoNS4HvRkqR4v+r2JGGLh9fYNz+XTytc88KWKWZjkuxfGF1rh12k7fBdJrwS4Y4ODW18Fh3najbGfFAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAKf2euZWIffXG+j03iJf+sW9LMkZzxtiDM47KlIHytz45raRe49888DCrTi8yxMEq9zAZmdux2+hpNRPdHelys446MJT5XXahezTxmwicTgI0TK6hAK/+TLgZJV2Px/ZAVZAF4573EwBMu3L8itu/r0pQoOjv2VV9URoXHuJOkWYHwPf3BSDsNP/4mZI2fbYMDF/v6wEMvGf0FGLsgmeqh62sYXpYXxajLJC/4Gv3LUDpDdHyUFF3FE3FY+ohqfGVWm1I/Om2N4BkS33jVuFXJvh4ZZdao264HuGIVElZuQidPdKXAAfUtVEPikYOv1swFlLkl1DeBJUhwTRjTq6X/g=
2036bdcc-94a5-4264-8f0e-1787b7f1b4a3	047e858b-661c-48f9-a2ed-8b4a3ab25ec7	keyUse	ENC
941f8e1b-6ff5-4534-b3e4-5279637776b5	047e858b-661c-48f9-a2ed-8b4a3ab25ec7	privateKey	MIIEpQIBAAKCAQEAxJWOhf4H34/PGs8GBVNwgK5BgQDyCA8X5mUgHKNwbyPaCkXmPNalkacvT7R950jyKJIxujJ69IPBwIxRS159je7mGxno1QUhYvDrOePQGLVUxIyzsJqTh80E/NKDQRFZFqXC/Or3pu20/3ddxp3WnPshpyj/s0iSYs2iUcNZNSVBaLHHlhtjD6FEzpTS16fFC1HWBD9cEKL6RS7oaBYNxIgNaUrHXbT+QpUkTY7+kybO1NGbZG002EzYna9J3rcs1Usw/Y5g6DUuB70ZKkeL/q9iRhi4fX2Dc/l08rXPPClilmY5LsXxhda4ddpO3wXSa8EuGODg1tfBYd52o2xnxQIDAQABAoIBAE2xpB4N67OuRRad2o3RT+XzuNzQ8FdCC9qZfgsDh2TNgRfNT3UdClvZ/Qdd2OLHgDmLqg6ic9jel/1PF7QXeLzXPedZIp3KRMszV2xOPsj9Ja72wu/Z79Pcsgtv8cMOJa0fP0SxYsZ9LStIVG4ypIbvc/n6aLDFTmGxTuVMtR2c1R2KAzznEq53UMTKFQ8Mcj8T9+gJ/v9/qXTYt0+WCt9MHBghTnjYHf87nmwAqFK2Xfti/lIje9BG50ORfkV1NB05/IMJLSlm0Eq9/Lj2crd3pM121b51GLPOYlqb6NzP20IiTWzI3Y4SX4du/bCdoZh7MRahrwoHj2GM4qd1h6MCgYEA98AF+HUWNjHqMQU/Hg2+FKDh9kJLHKLjQQjtP1I0BWqFUr8xNJFivdIL12ij04682PwbsF7bDpWBg2aWJ4KZX26KEW14CFt9hg1GC3J2Rg47+JZEEpjt3syLs0LBjGTxLLiMWc7ghm0PLNhQoB3yADaUA/krtfRDLgoESn8DL18CgYEAyyFdCLn7CzJ8nlGhje9cm5S2Q+Nmscv7hRCRvGASF48hVvifAYSEHbSGQnc/23w3T1cJvmVhJaVDLRA6d95GFQ2fhEbHXnqj+x+jsrmmMZrGuBFQ7+h/ERpOEDFbg+wIQms6+nMpT3P3XHj343KS4zOSi3vmMYPOOjtH89T8D1sCgYEAozEwfZ2amO4+JjYfgktpFqt2zECUu3MsIG2h4SDjtWGaGoxn/Al8Mi8Gr8h0iWkvSfqevols3+lpG0XayIHFR1BHz/z8oPyq7T8XEXk/IRxFMpTAmEN2BFlV+CmT1kezeVLC2HFmAgYahd6jFSVEgBFzZD6gJUWVbuEYPH33eh8CgYEAvoP1OQkN7uuUO/z+FBxK9FTfOf8fQ2S4642l0lMcxOHmeCbJI2hBbYbyYYZs6xOu4IgWyG9XVTKSNcLBw8lCW96iHTMxLGjEQfTj2O4MdPvgo6UCD3E1NDpCuyc/2RRYjsr5zwqR1UZD24RNoxLDt7qYGKDFPu2LT8xn6MZ6/n8CgYEAxzlRvZ0YcFd6cuEAImth5wPq2uMIztPrifBJ1/EyV22AGPs3KxW3/v6jKswpOwPUv75BGDOCsKdyWfHR+hwizwLjcOGhZvieSa0XCymSoEbexdRT1ozjG4hvrAmkTYfEqMVZFzkeRFmG719vi3Ps/fk+QhikyiO1HUi2jGOkmFA=
8934fe3a-4cea-4507-9d2a-3531b40ebf27	a089809d-98d9-4167-b5f5-a163e1fe0637	priority	100
1e5be86d-aa27-4bff-9702-07360b079f80	a089809d-98d9-4167-b5f5-a163e1fe0637	algorithm	HS512
d9877fcd-fac8-498f-af79-22ebe2d12278	a089809d-98d9-4167-b5f5-a163e1fe0637	secret	x29ykFGFeWPGjlt136NsEblDGKLxdqSlokjkwtH6VlO5yRKsoJSIJXWEYkeF0oSGEDQk1Pun20XND4bVn3XZgKb_W86R2uS-oNmJRH-QsvwgiSNpbGTvR-2t7QlQVYrjNhV-oTIQmBJD_xEEJQDWww_JOgOlc8-0Xbf-NuT5xb0
32e6d21c-4091-43a5-b25b-fff06d028009	a089809d-98d9-4167-b5f5-a163e1fe0637	kid	eff22ae3-f08d-4716-9594-fb894da74ccc
34cbc8c7-5a03-4e1d-93ff-408576b05ca6	71f205f1-9661-4758-91f7-f6ecf7d1631c	priority	100
4b074e89-78b2-492a-90f5-ff841aaa32e6	71f205f1-9661-4758-91f7-f6ecf7d1631c	keyUse	ENC
1793b37b-12dc-451d-b062-a75281cd58ab	0795d36a-9bca-467d-8392-300e167b80c3	kc.user.profile.config	{"attributes":[{"name":"username","displayName":"${username}","validations":{"length":{"min":3,"max":255},"username-prohibited-characters":{},"up-username-not-idn-homograph":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"email","displayName":"${email}","validations":{"email":{},"length":{"max":255}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"firstName","displayName":"${firstName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"lastName","displayName":"${lastName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false}],"groups":[{"name":"user-metadata","displayHeader":"User metadata","displayDescription":"Attributes, which refer to user metadata"}]}
e53404a3-c041-4e97-9c2c-f2911aeaf797	1253a969-8ef4-46c3-9d37-a3696b94cb78	privateKey	MIIEowIBAAKCAQEAv9TK/I2wdo1vve9Rj4UCWES2fLx7h/Tj8Jqcz1bfh+FVRAGCg2csms6iljA9QGQYF/SJnuiNuE7xTOp2EvetKLQpKpAdmvXatoEpALGBP91YCMZeY7FNC2k3AsivQnl0SO9oQ+jt0h2Vc7J3PDNiZA2Gg9aiAAYOg7AhuWiLuCDLZ0TNjm0qyLBvUdaffX3oMPhL+Bur4q0SgVOTWwUgG8VJA9KlBWFoUzIWhFXkWIfOQ3Y4bBUHcLo9DrrU5Ot/Q2CXPMtUkE5+eL7ifkAjUZuN/WgU+YFuXAt6ztlE7y74oIf8E0Dzy1kzw/o+sx8ZWUO7/5FitGARLH+Pts6z5QIDAQABAoIBABYxaiJ5yfaNOmZA77Co9LJ9kJcxvyDlhhFp8cZTCJ1RxmmNuym0oAZw7YJupkdyzQ7IbbuCsBKon2YEohBjsxbIcRLJhYNN+jWvD61S298lnm+1c2oZMw6k54Zc7VnFb1yYxflFU25Bme6+sOi4ESP+JJfQFwHlsXwuvlgS7kco4GeabiCWifYHEIb8ot1ztNPfKBSE9BM0u4FX3VEoxolDsNfrVBOVuAN8sNeWI1A+8gTQPxCJcERpENJ/gO/v2KysRtjK0bvmQMOJiUbYo+YVUOHlPWV1er6HkgFuEqevC1Jq8D0rHHthmiDy7ISIu6Mb+CMo0HL9OZcSyTYq+ekCgYEA/Kuextz9d0jdR4nI7TrlLnM9grihB4X9WvcyWkcgDD817EcH28AhMNT6BY9O0ybgKP7wiRq/G4jTOh1yL3++BEE2AEisXuIGGPtS9T29p28rl9w3jYGzC76qlFqQh4fx3+bBbzC3A7kot4ItgKkFxThflQf8fXTaLUvs9+PvGtsCgYEAwlvuw2aGX0W3P1jcz5CBSKU3pc54H5iOiVj9i7Kmn8dqfPYveJxejPF3VEYHTpB0uGLmqOBGs1J8Eo5pSAW7z0QtTpg54r+jVbIEG7LWiBUtex6ejojtx28tshYDDDeS5COmuOjojoshPZJ16zv1zYy/TqK732E7DJY2EdC0yD8CgYEAh+UGEI7rBCz8Vm2U04LJoKH6g0Qp15IJIdOyETwP0IZuyhWp9FbxgwIJNtRM4OQXy/TSCeuIvZZphOgxcbqSyFcKZDyx+JY4EVea1qvORS9VkueuOT14vuhddkz/TuWfAX1qrBLXW/lKHOi28Gv33orjXZReCFvAvHwJh4ngH+ECgYBcGE/Eyzn0vwYbwDGxMNnx4EfEC1ekMRepQT+zCE4n+8gbulO4JPAwfOJ8Tkp8Ebsc+9AsSUl3AyjDajO86uqZRcbqLPuQ1BnDK30C2vUIunA4nMOo6n0xOR8/+WosSdESxUnk6If5szdnA5VYh6rrYTvtOPMo39upFSw9uNVQ5QKBgHbDdmpSw4MqvyhJW7/4wtja5vG4ZzrSfx2yJg/GVQAXJJX3Y7TYEXgXPFbcN721/AcSPT2IMLt7XfETcZV6x8Pm5X4ngsiZV3FGWINZPZUhD81o2Dg1iq7Fz/KaPKZ02fkFtn51s4NF8VJjfEG6+WQLAaKYfSiS5uI2LaOZYVOZ
44b7a137-5eaf-43cd-8cc7-a247ca994f6f	1253a969-8ef4-46c3-9d37-a3696b94cb78	keyUse	SIG
712c0b31-b1a0-41e2-b262-50a5a3049488	1253a969-8ef4-46c3-9d37-a3696b94cb78	certificate	MIICmzCCAYMCBgGXorkpJDANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjUwNjI0MTYxMzUzWhcNMzUwNjI0MTYxNTMzWjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC/1Mr8jbB2jW+971GPhQJYRLZ8vHuH9OPwmpzPVt+H4VVEAYKDZyyazqKWMD1AZBgX9Ime6I24TvFM6nYS960otCkqkB2a9dq2gSkAsYE/3VgIxl5jsU0LaTcCyK9CeXRI72hD6O3SHZVzsnc8M2JkDYaD1qIABg6DsCG5aIu4IMtnRM2ObSrIsG9R1p99fegw+Ev4G6virRKBU5NbBSAbxUkD0qUFYWhTMhaEVeRYh85DdjhsFQdwuj0OutTk639DYJc8y1SQTn54vuJ+QCNRm439aBT5gW5cC3rO2UTvLvigh/wTQPPLWTPD+j6zHxlZQ7v/kWK0YBEsf4+2zrPlAgMBAAEwDQYJKoZIhvcNAQELBQADggEBACDkPtSfuUy+fecV8en0czDE4IuYMDFdwOLi2mNErxpxt0PgbfuR7SiAF4gVNgSWfp14r+rCG3J2+HRVYdVJM2+uo159zQzMu3t2Q47rKiBet4hde+dLjegFW/bjvgsltuGjrXVBh96YTw/ADzxbuG0WGdMRNSzAkyGOWrCkbrYvedJ4wesK6Vw1QXUPSfZABSmtsGjZAuPYjRzqzUSA4iDa8wUOJm/aJfLa16rZz27cSRcV6R0DLx0jpwfyN/YNKJU+SGRfVAqHOTRKlnDnfbU7eo5Wrb0xo4ipCwCEnjRTaAsfqIm8pk5OAWYs7xuCxVk9Hi1kuY9Flto4kvRLd2s=
ffaf9603-1540-4fcd-9c03-5a286dac0448	1253a969-8ef4-46c3-9d37-a3696b94cb78	priority	100
8294162c-0dcd-4960-b205-8271070f92c2	5489f72b-e1c1-40ed-8860-68a1892a33ae	priority	100
6ef235a7-fd61-4afa-b2c4-e40bf03c85f2	5489f72b-e1c1-40ed-8860-68a1892a33ae	secret	AwzswyxW1JTblZGGUmeAtQ
00cc270d-895f-4938-a9b1-1b7c8413dacc	5489f72b-e1c1-40ed-8860-68a1892a33ae	kid	9ca1523e-eb2b-4d9e-b522-8c2b5283ff8b
016c8be2-4b95-4429-8464-c7f8874abfb3	af488bd5-4ba4-4d10-9f0d-4a4da0e511f1	priority	100
57c68f06-1854-40ae-967b-0d9b65d812f7	af488bd5-4ba4-4d10-9f0d-4a4da0e511f1	kid	23da0bd8-ddfe-4abd-8aab-83fbaf7fa8af
ba83b9df-142b-4b08-90ba-15623545ee50	af488bd5-4ba4-4d10-9f0d-4a4da0e511f1	algorithm	HS512
05ddcfaa-c1ae-4301-b361-6cf96087b4be	af488bd5-4ba4-4d10-9f0d-4a4da0e511f1	secret	ZpmYTgRcipRCEeLcwSIOL5P2p2h_LAIr3B9-ph0ignM4hw_aJRGNz6WYv_xzSMR1DwvL9NsC8NpZqqctU0Y9Vf93K36sFN13rCuwE5_9g-pqt0A7bHn5iGSW4vqZxzEp6BbGuS_8cTyWmEcq4pceh5tQ8-7gk-p_S7igkr9bbxk
114b5714-36dc-4ea0-8aa7-375acfaac01e	efed6c49-d4cc-49ec-bb30-6df3ce164dfe	privateKey	MIIEowIBAAKCAQEA3a5jvY7nYDZ0DPeQO9q5qjURdB0RV92zvOVZINzh/H8EQb+UfNlwJvpJa72EaqSxn8NTwuJ2sQDcRvnH3JYkJCS+PR9A8dSwh5JIt9Ms0BeYFlLVO3lqHRrttq7MIlk3gP5MwtlgFbyvGrsH9Xf7/6rEdRn8+zUtJjk5APSD9eZMhrgD9MT7xu3pBhX093Dy+YSH+Er5KOo42KNvmw3/03zNYivK9k/+ORa9QkCr7eLUBhwozukbCbKVC04B2sNQcOc/QEzMkXcDkT3MPtv+vXHoi2twUkpc6O2nRZ2qZl0/olep5F4MnTN5cexaOygNDCYSo3a27rRVjO/IlBtOCwIDAQABAoIBAAHHK13FEQK65jisHjgbiVtCV9kjER548D8v+ARlGkjpznXc02+QDy/dasLorN5JPpfBYDyuj5mTaUMrCv2LuU8y52NtHPYF38MqCLMidfgyKWR5llHQA0XMWJC/5JbTXe8ZSMR4vkrC6XKg8B15sIfPElOZQoxmHJLOskJHDzZ3LRWCcHr0hLAAgEZwYL+ONwbNcBrtjf+lzKkbtnm9Lo1cJqQ70GqqJ2haXvtPC43W0qjbmEt4jYWxeI/N8CmHnJE7RSkJHYKG/oOtOtnmt04QVKDWq6UJdS3n3naUudU3Uwtf2anpnObwniG0KpZ09WoOMlsWx6rKMKh118tiOZECgYEA76iqj8Ya0K19G8xepGg+8gLNPtUSp0j/0T+17MeqDRUMEn/4sWmLL4Neo3asbplgd5Me74P4b54O8fzPCdPGuY90MJn7eaidCa+uEZ1p+S1Tbs3/uMgveFXdV1tyrQA2bI5ygql9OkKhi8S8m/Ue4PNnJ5h1ThG2slbDnKDmJpsCgYEA7MvqvbRaZq4iXEPwRlRaYvxnUd1tplgZkLnl9McaeYZDpRfl5zAqUQUSjwucB3dSWu9VlDHc8tLJdzrHwpwOY1UpZUKoKmrQof6hCiAbrvrrdA6J2dfW88YA7i/KJinJ4pDMVNAEFPsIy/M+ANTQtKFNNO5p7NjixbeL0S8RNVECgYEAsFCfQu0VF0c7jrL5Qe0rufKTu1EYyxeqlPBRUGTIV52PZyDc/vDOJGN6wbnyO9/9F5uWG9I0eTGIf0FltC4ouqWubn8qgqOo/NJRtsXfjCFri05kfzZPrjFFiRpPMLXCVHUsC7LT3YPdw602sWpRkF+iGYBRdOEVTvkEKnw5NlcCgYAUVqtx4dTF7vz6icdQcxxUVjOVn3w0hmqjuKPcs2E9wN98haH0inmH/fSLHscnCQOk1du239WHcb1mJUFVIMxHkd/9V41UH1qOH227jehyzhB9JmaGtHg89evMiYRGZN53PFKgkkFXf/xQcDMKJT1L1nLoMfYdJr/LlalHrVBAEQKBgGK5Mp0hclAPscutf7KZfYxiACwzTtJTX02ZDt4TRJjVkTonzh2XzrzwPNk67wYEZ0ApTxYumEUrmdUw/Y++sGH5ebq4M1LgjrrDhvWBtpzasVIByE2m+FlL1Fmp16qruMPdkTkx+fqLuzgi4UoQ9Qk2iqCAdy+fKO8pDDbsapnX
464a86bc-d617-40b0-97f6-3120d5d268bd	efed6c49-d4cc-49ec-bb30-6df3ce164dfe	certificate	MIICrzCCAZcCBgGXorkvnDANBgkqhkiG9w0BAQsFADAbMRkwFwYDVQQDDBBuZXh0anMtZGFzaGJvYXJkMB4XDTI1MDYyNDE2MTM1NFoXDTM1MDYyNDE2MTUzNFowGzEZMBcGA1UEAwwQbmV4dGpzLWRhc2hib2FyZDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAN2uY72O52A2dAz3kDvauao1EXQdEVfds7zlWSDc4fx/BEG/lHzZcCb6SWu9hGqksZ/DU8LidrEA3Eb5x9yWJCQkvj0fQPHUsIeSSLfTLNAXmBZS1Tt5ah0a7bauzCJZN4D+TMLZYBW8rxq7B/V3+/+qxHUZ/Ps1LSY5OQD0g/XmTIa4A/TE+8bt6QYV9Pdw8vmEh/hK+SjqONijb5sN/9N8zWIryvZP/jkWvUJAq+3i1AYcKM7pGwmylQtOAdrDUHDnP0BMzJF3A5E9zD7b/r1x6ItrcFJKXOjtp0WdqmZdP6JXqeReDJ0zeXHsWjsoDQwmEqN2tu60VYzvyJQbTgsCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAluDaLZY22PBPhJIVYJKiOw6uIAY3fJ5hTRreN5FcPBwm6C0WH6F1PwK3XzmSzZsI0vynYtAWkoeRKZl5cUX+SywRUhUCA4ChIZ2zizgMpK/789mJBWIulZBO2b/dZj6474clo3UOhuwel/LCTMg6ewJ9JHwwgj/q2DQqcqypWB2kGsSNRiuj6wKsCL5uQiz1IlCA/GhnsfZol5S7EsYa5o4Rs2iHkahmhyMnGoo3eitHtKe+YhaTgwJo7UcEZ4xxdKhKY739F/jpmKLNPFMrGhBr53CS4pgV1CnJbEpYCC4OE1KaZ//IEmg2uagG15MfyQqw9hTCi5FObW8/krtlWg==
7b0dfb8d-63b9-4b75-a9b4-649e263911bd	efed6c49-d4cc-49ec-bb30-6df3ce164dfe	priority	100
3f191fb1-fddb-4bd8-845a-30bb18fa1f03	efed6c49-d4cc-49ec-bb30-6df3ce164dfe	keyUse	SIG
397e970a-4f3e-43d7-931f-bf64080ce8ec	71f205f1-9661-4758-91f7-f6ecf7d1631c	certificate	MIICrzCCAZcCBgGXorkwVDANBgkqhkiG9w0BAQsFADAbMRkwFwYDVQQDDBBuZXh0anMtZGFzaGJvYXJkMB4XDTI1MDYyNDE2MTM1NFoXDTM1MDYyNDE2MTUzNFowGzEZMBcGA1UEAwwQbmV4dGpzLWRhc2hib2FyZDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAK3CpPr0UhFHTCjesYOxFQ9nR+yqp5syeTKVRcZCG3FsfZCdgcx40DD3DyZNu97obDEb1wLu6q0TbdGBVNBpKMk7VuuI3LFc1AWGWc8y4zgY3Tp3cbEPNlDmfUqa4M6g23ogLZMzOsL78PcdCn7aX6WgPWagOWbfxkpsvJKcCci/gwwWYHSmEUydOtqmTFZbsc1sTaIkcHH8BcDawII2RdRyuVIP9lK8fANkC6l5eOk7TXxZDGIoWm+tU5YS8kglswXAamIkHB/NFJWpSg4Nc1DbQPUnEDQyArox7PGjVAgOCleAlj9F7c5yU0msSi/JjgRqtZwATn9u2iLtW7qRMwkCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAcOSW24Vbzq3yZVo1Zh+8/WIFOSbmaz4LmB7jHm7LurnvcvRs3CHjuaGeTsa1WKxwop0HVT7NtbrxQ47pUAm5yB0xmF9vrxNTNCZB50epGXeIfx+OnDA5k1Aak+Yv9/QtB7qY+V5RneEocIAiuvP7xBwb+FcO8W+5zO9C5gVxwGdn/8llDjPiGdEvLAtjKnJmFJUbbrCwmYtLCxAIw8NY3SaDZvTGGRZQwZNcCATplFDvAzhQYk3M/fFfRvF0+2IKWn2EFKE2cJvqEZIgS3bM+Y2LT00Kib+Xh1S6Eta+S055GCCcdU2gSKrvrsBlMQiwYBM/kR/wPtCqa+P5DnQBWQ==
09e15851-2d8e-4ace-9dc0-22d42f69a377	71f205f1-9661-4758-91f7-f6ecf7d1631c	algorithm	RSA-OAEP
a6a8a5f6-3942-4bd8-b526-785e335abbff	71f205f1-9661-4758-91f7-f6ecf7d1631c	privateKey	MIIEowIBAAKCAQEArcKk+vRSEUdMKN6xg7EVD2dH7KqnmzJ5MpVFxkIbcWx9kJ2BzHjQMPcPJk273uhsMRvXAu7qrRNt0YFU0GkoyTtW64jcsVzUBYZZzzLjOBjdOndxsQ82UOZ9SprgzqDbeiAtkzM6wvvw9x0KftpfpaA9ZqA5Zt/GSmy8kpwJyL+DDBZgdKYRTJ062qZMVluxzWxNoiRwcfwFwNrAgjZF1HK5Ug/2Urx8A2QLqXl46TtNfFkMYihab61TlhLySCWzBcBqYiQcH80UlalKDg1zUNtA9ScQNDICujHs8aNUCA4KV4CWP0XtznJTSaxKL8mOBGq1nABOf27aIu1bupEzCQIDAQABAoIBAAab/O7cxJMKrWTFP7xSITUc88Pr+S8dPDXxLp5sHPjIrH1dOGGLhjkZP1bGJdYZ7M+bZFIkvgFyV+mHAVpiEvPrPBL+eY03ijW27AtGahUpVko8iTMNGz74MsjX26LlxHjAk5Xh9iNni5K4Dzz5rSIIK9MPrM9IcMBGTY/yu9PfwNfywT+3KtXVGbkpbmO5yGsMmEbLwVk9reRE9F31x5JB4dZ9R1JkO45e6vyggI08xBxU46Q3lMfFXWd4i26R4D49AgfyU/I3flYaKDk6+kGjzCmyvDEsbkHBdWIyv2Lv/H4WVATsFZQYTWoG7j73fy9MnLxfufEEmasCl0wgEoECgYEA7QmK/xyVcywbyEpc6xgsOO/KO+63Hnb0po/T2wUIFo7nK9hg7GxRk/Uze/2wa5N+C6tK7HdouxXIevOWV3hzea2l7aACUPuexa3YAVJaRxvZWmQQzCL0y/hYcK3zbnuQfLZSO8fuUylRvEp46UZsVd/FXhsYdm5e/b4k3y0UPikCgYEAu6k1FGCqZbarJx/wsq45c/QjkUrzB9XrRXRpBieRz+YllZ5VbEfrmuMYTkRoUA/J9Jj3iOB5LKO7wB/u5X4brRYLkalLYO8CLayQQyF7zf1xuIsBFn9dwg9lW6SQ1wzE0C9loFLxivubs82UvTFp3pAwD6uUPEnUnxLkWoWCKeECgYAWPILxk7jhaQ3iKDe3Rjk/zh7mqGo9TWN+DJgPP9WWaCl/j3joNPEiNCp0Q0Q9k0SLy7HnpPwKMOzxu9AqvH34uDWMqSoOdsxaNwjAdv1JFm+5bxG0VMMqL038pBTmFGlliaUFPqg43PNx+nqFR7n6BFf7kAcndQssOp4y4YO4oQKBgCQ0jQ0VaUqeZ37w5ptSibsZSxNpBmJony+TOf/5+mPF31JybcCqT4Zecf4HrKhlo20RZhB+XmKCZGK4xnp4ThaivjCoHObiteTh+iM5fo1LbHlSOC+C+y/JkKCRq3ASApa3zj+UQQ2zZWLXMu8dbXOHFf6v97V5+Q+HsY7VWzuBAoGBAIwHoxyJIeu1esxWKGJFdNzptVT9fqFBX8EEodZ1CO3wrTF2flwEspf8075hycN+agENDCbXWJSShIywUM4K8uXWuMGi275fNvOh+N7Cx87GD1KglF0HeXvrpCoZZcCbF/QHSGCYdxicvK8pWhxwXl9oB8HmPPKPTyVEG0PE/MkU
13d35eb0-bd24-46bb-ac3b-fafcc91dd338	586f8092-e1eb-4f53-adb0-13ae57fd9c9e	allowed-protocol-mapper-types	oidc-full-name-mapper
3e9b19b6-601a-4d76-b0ab-f7b7d3149353	586f8092-e1eb-4f53-adb0-13ae57fd9c9e	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
f499913d-6304-477a-b57f-fdc5b533af26	586f8092-e1eb-4f53-adb0-13ae57fd9c9e	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
e06b00cd-aa39-49bb-8551-70c9eb431591	586f8092-e1eb-4f53-adb0-13ae57fd9c9e	allowed-protocol-mapper-types	saml-user-attribute-mapper
5698a8e2-b674-4fa4-8b30-6fcbddb31fca	586f8092-e1eb-4f53-adb0-13ae57fd9c9e	allowed-protocol-mapper-types	saml-role-list-mapper
e6e29f57-bd98-4022-a8a3-79e51101d9ae	586f8092-e1eb-4f53-adb0-13ae57fd9c9e	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
370b3e36-74f9-4b78-8a6f-2fc58edcc820	586f8092-e1eb-4f53-adb0-13ae57fd9c9e	allowed-protocol-mapper-types	saml-user-property-mapper
1247296d-3c51-4a90-b5b7-b94014fb1767	586f8092-e1eb-4f53-adb0-13ae57fd9c9e	allowed-protocol-mapper-types	oidc-address-mapper
23bd4d3a-de3f-4833-866d-1c523ab0f581	2c981e81-9e87-4554-b03c-6fdbf1694394	allowed-protocol-mapper-types	saml-user-property-mapper
0eddd7dc-c5ab-4ad4-894f-31e4af0090f3	2c981e81-9e87-4554-b03c-6fdbf1694394	allowed-protocol-mapper-types	saml-user-attribute-mapper
8aee905b-2c51-4d8c-870e-b1582c83c9f8	2c981e81-9e87-4554-b03c-6fdbf1694394	allowed-protocol-mapper-types	oidc-address-mapper
2929ed3d-0ec4-4dc8-bf62-82c5d2af8196	2c981e81-9e87-4554-b03c-6fdbf1694394	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
8960d4e9-9c71-46db-b8e9-963b22d9556d	2c981e81-9e87-4554-b03c-6fdbf1694394	allowed-protocol-mapper-types	saml-role-list-mapper
503a0bf8-3ff3-4462-af31-dd4cac279bcc	2c981e81-9e87-4554-b03c-6fdbf1694394	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
a8045443-8820-4216-8b48-1a4738c78280	2c981e81-9e87-4554-b03c-6fdbf1694394	allowed-protocol-mapper-types	oidc-full-name-mapper
292839fa-161e-4bb0-a864-ccb2ff45decb	2c981e81-9e87-4554-b03c-6fdbf1694394	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
1a608f68-fb02-4a98-a3cd-a23e397c43c5	b71bf5a6-37ea-4c32-822f-de4797bb074a	host-sending-registration-request-must-match	true
140f7c77-6dd1-475f-bd4a-04a083ddd7a2	b71bf5a6-37ea-4c32-822f-de4797bb074a	client-uris-must-match	true
2c6d988e-2e20-4ab6-8cdc-4a06925190e4	164683a5-7f15-484f-828a-3bdcfcee8f8c	max-clients	200
468a9c06-8826-4ad0-ab1d-e06bb97dd4fe	433d2e7e-ee04-4530-9555-76d4f0ac6c9f	allow-default-scopes	true
aeb5ab2e-5006-4a8f-b4c8-00636d1bb7bd	bf606f65-9004-466b-9d40-a6b50b2bd640	allow-default-scopes	true
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.composite_role (composite, child_role) FROM stdin;
e4bc0604-3995-4e2f-a040-0f0a87d89eef	43aa79a0-a270-4ff7-8ebc-886c82c232ff
e4bc0604-3995-4e2f-a040-0f0a87d89eef	5c595a70-9c94-4dfc-ac0d-13405acd86d8
e4bc0604-3995-4e2f-a040-0f0a87d89eef	9e1833a4-74ef-41c0-a16a-f39d15d87bb8
e4bc0604-3995-4e2f-a040-0f0a87d89eef	3b4e72e2-d7a3-415d-93e6-daf27b8ba77e
e4bc0604-3995-4e2f-a040-0f0a87d89eef	429d2b87-c91d-4529-a339-43ed4f1190e6
e4bc0604-3995-4e2f-a040-0f0a87d89eef	d4dd2e70-f84f-4462-a986-157efe8ff006
e4bc0604-3995-4e2f-a040-0f0a87d89eef	b36157c0-3adb-45ae-87ec-23986c5a5d12
e4bc0604-3995-4e2f-a040-0f0a87d89eef	a0c7e81f-9d87-42d1-ae08-ced0ea36a956
e4bc0604-3995-4e2f-a040-0f0a87d89eef	c5977078-05ed-4923-9525-12aa1026adbd
e4bc0604-3995-4e2f-a040-0f0a87d89eef	f3a2080d-0070-4de4-aae6-3891c5dc259e
e4bc0604-3995-4e2f-a040-0f0a87d89eef	69e494dd-7d92-447d-a9e1-719f6436b781
e4bc0604-3995-4e2f-a040-0f0a87d89eef	be5b64b7-105e-445a-9a8b-145032bc3b58
e4bc0604-3995-4e2f-a040-0f0a87d89eef	389c6530-1195-4cbd-9775-e6a9c386c5cc
e4bc0604-3995-4e2f-a040-0f0a87d89eef	1bdf67d2-3c0a-42e1-aba1-01819e0eb266
e4bc0604-3995-4e2f-a040-0f0a87d89eef	60a7d234-81e1-44bc-ad02-202dd4fb5d10
e4bc0604-3995-4e2f-a040-0f0a87d89eef	989e71ec-ae67-4be3-abd9-dbab1a1fa7ea
e4bc0604-3995-4e2f-a040-0f0a87d89eef	0c444e00-9b67-457f-93d1-368d8567023e
e4bc0604-3995-4e2f-a040-0f0a87d89eef	1c5ca66c-929c-4383-9d7e-23a379b211f4
3a60f580-118b-4313-9862-5e2ea6468ae3	25b80856-7e1a-439c-8573-834d4b540b6c
3b4e72e2-d7a3-415d-93e6-daf27b8ba77e	1c5ca66c-929c-4383-9d7e-23a379b211f4
3b4e72e2-d7a3-415d-93e6-daf27b8ba77e	60a7d234-81e1-44bc-ad02-202dd4fb5d10
429d2b87-c91d-4529-a339-43ed4f1190e6	989e71ec-ae67-4be3-abd9-dbab1a1fa7ea
3a60f580-118b-4313-9862-5e2ea6468ae3	d064310e-a85d-4180-a449-fb2b57cd41d3
d064310e-a85d-4180-a449-fb2b57cd41d3	51ae94f8-5d79-48cf-b6f7-1effe5cb61fe
70b37896-b52e-4898-9195-16f6af7c46e1	71595598-747d-4c05-adc2-6a65a2edaba3
e4bc0604-3995-4e2f-a040-0f0a87d89eef	888984ca-844b-431e-811f-ab45a3f9f18b
3a60f580-118b-4313-9862-5e2ea6468ae3	eaae3760-7633-468b-aa11-def248b30acb
3a60f580-118b-4313-9862-5e2ea6468ae3	27b438e3-336a-4f52-9ebe-272dc4dca2c9
e4bc0604-3995-4e2f-a040-0f0a87d89eef	f9081211-adf8-4217-8c9c-e2bb15e79457
e4bc0604-3995-4e2f-a040-0f0a87d89eef	856585b5-b4a5-4605-be67-8b1010e1306e
e4bc0604-3995-4e2f-a040-0f0a87d89eef	b78df878-9033-4a71-bbe7-aa8c57fb04e6
e4bc0604-3995-4e2f-a040-0f0a87d89eef	4c0df749-b572-482d-b7f3-4a1c84467895
e4bc0604-3995-4e2f-a040-0f0a87d89eef	3f64a199-df0a-4634-97e4-4cbab1e71d1c
e4bc0604-3995-4e2f-a040-0f0a87d89eef	00f9037b-1280-4064-9b3c-cd671231325f
e4bc0604-3995-4e2f-a040-0f0a87d89eef	b4687db6-8738-423a-a44b-cb312f06f8ee
e4bc0604-3995-4e2f-a040-0f0a87d89eef	66beb2b9-0760-4e01-b240-66345c8789bf
e4bc0604-3995-4e2f-a040-0f0a87d89eef	688954e3-6c54-4dc9-ace2-42ac946b468b
e4bc0604-3995-4e2f-a040-0f0a87d89eef	556ba6df-29fc-4547-b12b-1b451f5573b1
e4bc0604-3995-4e2f-a040-0f0a87d89eef	abe4a23e-5964-4c9a-9007-1ad42921df6f
e4bc0604-3995-4e2f-a040-0f0a87d89eef	148ab9a3-659b-4857-aed2-a73f8abf8bd2
e4bc0604-3995-4e2f-a040-0f0a87d89eef	caf4207e-2a25-4e56-a4e4-2e7fb0eea705
e4bc0604-3995-4e2f-a040-0f0a87d89eef	c361f50e-361a-4498-90e4-ef3928d784ae
e4bc0604-3995-4e2f-a040-0f0a87d89eef	e4dc275f-5988-479b-aa5d-bf78e0ac9d57
e4bc0604-3995-4e2f-a040-0f0a87d89eef	59a993d5-1261-4300-8ffe-5e4642fcc3e7
e4bc0604-3995-4e2f-a040-0f0a87d89eef	47c71bd8-59ea-423c-929f-cf7f9603b9ac
4c0df749-b572-482d-b7f3-4a1c84467895	e4dc275f-5988-479b-aa5d-bf78e0ac9d57
b78df878-9033-4a71-bbe7-aa8c57fb04e6	47c71bd8-59ea-423c-929f-cf7f9603b9ac
b78df878-9033-4a71-bbe7-aa8c57fb04e6	c361f50e-361a-4498-90e4-ef3928d784ae
039ef22d-8b23-4b53-b9a3-5cc4c045106a	8454fee2-3bc4-489b-b5d5-506b198e5d9b
039ef22d-8b23-4b53-b9a3-5cc4c045106a	d39a71e7-af44-44ab-acbe-a8b775bb7cc0
039ef22d-8b23-4b53-b9a3-5cc4c045106a	60b24f76-8155-4148-8393-6e901d8cbcf9
039ef22d-8b23-4b53-b9a3-5cc4c045106a	8001e5fe-28ba-4edd-8965-aac813d72ac0
039ef22d-8b23-4b53-b9a3-5cc4c045106a	30aa02d9-cb2b-4296-acb5-cb793f6ce168
039ef22d-8b23-4b53-b9a3-5cc4c045106a	99004025-3a53-4034-af27-f6f4f43c9b6c
039ef22d-8b23-4b53-b9a3-5cc4c045106a	94241f64-7db6-42a3-9a50-203be4be51e7
039ef22d-8b23-4b53-b9a3-5cc4c045106a	a005ca50-933e-4db6-9ea2-347884029741
039ef22d-8b23-4b53-b9a3-5cc4c045106a	15800581-6ec2-42f0-9c41-2f2729999d4f
039ef22d-8b23-4b53-b9a3-5cc4c045106a	972c32be-9cd3-4007-bae1-55d889a17e95
039ef22d-8b23-4b53-b9a3-5cc4c045106a	f9f8d363-c92f-4507-bdeb-86502debb23e
039ef22d-8b23-4b53-b9a3-5cc4c045106a	e87a45b9-e1ed-414c-97dc-6457c75a7dbe
039ef22d-8b23-4b53-b9a3-5cc4c045106a	2a623913-f224-449c-96be-bde34c5c38df
039ef22d-8b23-4b53-b9a3-5cc4c045106a	0f70a87a-27f6-474e-a9db-6e9e31e5c378
039ef22d-8b23-4b53-b9a3-5cc4c045106a	edb6a370-faf8-4585-b4b4-11bf0e3686f6
039ef22d-8b23-4b53-b9a3-5cc4c045106a	1b645b0a-a9e1-4019-857e-29e3b2be12bd
039ef22d-8b23-4b53-b9a3-5cc4c045106a	e8d9c21e-8eb4-4d30-a313-db934f7f228a
32d78998-b4a3-4358-9f41-9fb89659de0b	09ddac52-762c-464b-9011-a1cff339f646
60b24f76-8155-4148-8393-6e901d8cbcf9	e8d9c21e-8eb4-4d30-a313-db934f7f228a
60b24f76-8155-4148-8393-6e901d8cbcf9	0f70a87a-27f6-474e-a9db-6e9e31e5c378
8001e5fe-28ba-4edd-8965-aac813d72ac0	edb6a370-faf8-4585-b4b4-11bf0e3686f6
32d78998-b4a3-4358-9f41-9fb89659de0b	e5ca7bde-db56-490d-afe1-25f4d5636935
e5ca7bde-db56-490d-afe1-25f4d5636935	d61213bf-dbdb-4c2d-a4eb-5a1492f24d62
fafef884-34e4-4dc5-8796-2c56aaa97fe0	2e9319f4-086d-43e7-94a9-022e66ce35e3
e4bc0604-3995-4e2f-a040-0f0a87d89eef	009e89f7-c032-4775-a630-fde9b44cf5f2
039ef22d-8b23-4b53-b9a3-5cc4c045106a	3647a876-c772-4463-a922-b8924d0c084d
32d78998-b4a3-4358-9f41-9fb89659de0b	5926e4b6-ce4f-44c7-b71f-3ec7ffb9cdd6
32d78998-b4a3-4358-9f41-9fb89659de0b	d42a8b82-d043-4511-b13a-f745401e871d
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority, version) FROM stdin;
84918289-b4ba-40a2-b304-bf2531bbeaf5	\N	password	e4d137a8-ca21-4bd5-80dc-69cee3432bdb	1750781734560	\N	{"value":"Q+AR1dGqg788MVCT0ScLB8h+7ZrrEmO/hXLWAuTNogo=","salt":"LOv8Ip0BUCFKnyHb96f4mw==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10	0
1163bc89-028f-43e6-a10f-3336d5382c7f	\N	password	ecacf8de-e81a-4ca7-83d6-d7fc200bf9a4	1750781734627	\N	{"value":"Ksj3uKTW2jYojQ/6af3iS0DX0uQAWSojpuCXjYgAv2g=","salt":"6+iHLZjWWYwMkS9DXmq9xg==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10	0
f61ad28f-8d7d-4cc2-a541-4a7607a1e74f	\N	password	15d36145-5cea-49e5-9f9f-fe71bfe502fb	1750781734673	\N	{"value":"Uv/2yUlsCfdtU48X+lblcu0aVD01ev1xLNMniKV/kn4=","salt":"MmEFGvefmgtdM9UJl255sQ==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10	0
e0109d3d-4e81-4bec-bb52-aef06bd5e6bf	\N	password	9849c786-ce3e-40db-8322-5c53c3d80651	1750781735224	\N	{"value":"SbMN9WuuW7F14rT4SXOLF0y3KNejFXzJXknbFJQVqCg=","salt":"qbziGwbigt6SX0l/4CZ8fA==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10	0
8dce8a88-d9d5-4c9c-993a-de27a80b7df0	\N	password	b1c7bfb6-8279-42c6-8cd5-2ac227717fb1	1750959726493	\N	{"value":"fAJUF9so9jzs7YlQIQRWQf+bd7Kk2SL3ppo00X6aaYY=","salt":"dWspPXiLghrBjogEi2aYAQ==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10	0
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2025-06-24 16:15:18.749097	1	EXECUTED	9:6f1016664e21e16d26517a4418f5e3df	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.29.1	\N	\N	0781718282
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2025-06-24 16:15:18.77035	2	MARK_RAN	9:828775b1596a07d1200ba1d49e5e3941	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.29.1	\N	\N	0781718282
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2025-06-24 16:15:18.82367	3	EXECUTED	9:5f090e44a7d595883c1fb61f4b41fd38	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	4.29.1	\N	\N	0781718282
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2025-06-24 16:15:18.833618	4	EXECUTED	9:c07e577387a3d2c04d1adc9aaad8730e	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	4.29.1	\N	\N	0781718282
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2025-06-24 16:15:18.942162	5	EXECUTED	9:b68ce996c655922dbcd2fe6b6ae72686	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.29.1	\N	\N	0781718282
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2025-06-24 16:15:18.953665	6	MARK_RAN	9:543b5c9989f024fe35c6f6c5a97de88e	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.29.1	\N	\N	0781718282
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2025-06-24 16:15:19.061814	7	EXECUTED	9:765afebbe21cf5bbca048e632df38336	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.29.1	\N	\N	0781718282
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2025-06-24 16:15:19.071675	8	MARK_RAN	9:db4a145ba11a6fdaefb397f6dbf829a1	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.29.1	\N	\N	0781718282
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2025-06-24 16:15:19.084891	9	EXECUTED	9:9d05c7be10cdb873f8bcb41bc3a8ab23	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	4.29.1	\N	\N	0781718282
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2025-06-24 16:15:19.193105	10	EXECUTED	9:18593702353128d53111f9b1ff0b82b8	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	4.29.1	\N	\N	0781718282
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2025-06-24 16:15:19.26714	11	EXECUTED	9:6122efe5f090e41a85c0f1c9e52cbb62	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.29.1	\N	\N	0781718282
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2025-06-24 16:15:19.276617	12	MARK_RAN	9:e1ff28bf7568451453f844c5d54bb0b5	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.29.1	\N	\N	0781718282
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2025-06-24 16:15:19.315841	13	EXECUTED	9:7af32cd8957fbc069f796b61217483fd	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.29.1	\N	\N	0781718282
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-06-24 16:15:19.341778	14	EXECUTED	9:6005e15e84714cd83226bf7879f54190	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	4.29.1	\N	\N	0781718282
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-06-24 16:15:19.346507	15	MARK_RAN	9:bf656f5a2b055d07f314431cae76f06c	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	0781718282
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-06-24 16:15:19.35257	16	MARK_RAN	9:f8dadc9284440469dcf71e25ca6ab99b	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	4.29.1	\N	\N	0781718282
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-06-24 16:15:19.360146	17	EXECUTED	9:d41d8cd98f00b204e9800998ecf8427e	empty		\N	4.29.1	\N	\N	0781718282
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2025-06-24 16:15:19.422668	18	EXECUTED	9:3368ff0be4c2855ee2dd9ca813b38d8e	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	4.29.1	\N	\N	0781718282
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2025-06-24 16:15:19.494143	19	EXECUTED	9:8ac2fb5dd030b24c0570a763ed75ed20	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.29.1	\N	\N	0781718282
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2025-06-24 16:15:19.505826	20	EXECUTED	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.29.1	\N	\N	0781718282
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2025-06-24 16:15:19.517139	21	MARK_RAN	9:831e82914316dc8a57dc09d755f23c51	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.29.1	\N	\N	0781718282
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2025-06-24 16:15:19.524236	22	MARK_RAN	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.29.1	\N	\N	0781718282
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2025-06-24 16:15:19.696583	23	EXECUTED	9:bc3d0f9e823a69dc21e23e94c7a94bb1	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	4.29.1	\N	\N	0781718282
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2025-06-24 16:15:19.709099	24	EXECUTED	9:c9999da42f543575ab790e76439a2679	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.29.1	\N	\N	0781718282
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2025-06-24 16:15:19.713884	25	MARK_RAN	9:0d6c65c6f58732d81569e77b10ba301d	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.29.1	\N	\N	0781718282
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2025-06-24 16:15:20.299863	26	EXECUTED	9:fc576660fc016ae53d2d4778d84d86d0	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	4.29.1	\N	\N	0781718282
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2025-06-24 16:15:20.368312	27	EXECUTED	9:43ed6b0da89ff77206289e87eaa9c024	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	4.29.1	\N	\N	0781718282
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2025-06-24 16:15:20.376005	28	EXECUTED	9:44bae577f551b3738740281eceb4ea70	update tableName=RESOURCE_SERVER_POLICY		\N	4.29.1	\N	\N	0781718282
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2025-06-24 16:15:20.425635	29	EXECUTED	9:bd88e1f833df0420b01e114533aee5e8	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	4.29.1	\N	\N	0781718282
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2025-06-24 16:15:20.445883	30	EXECUTED	9:a7022af5267f019d020edfe316ef4371	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	4.29.1	\N	\N	0781718282
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2025-06-24 16:15:20.468944	31	EXECUTED	9:fc155c394040654d6a79227e56f5e25a	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	4.29.1	\N	\N	0781718282
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2025-06-24 16:15:20.47597	32	EXECUTED	9:eac4ffb2a14795e5dc7b426063e54d88	customChange		\N	4.29.1	\N	\N	0781718282
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-06-24 16:15:20.486831	33	EXECUTED	9:54937c05672568c4c64fc9524c1e9462	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	0781718282
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-06-24 16:15:20.49213	34	MARK_RAN	9:f9753208029f582525ed12011a19d054	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.29.1	\N	\N	0781718282
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-06-24 16:15:20.520134	35	EXECUTED	9:33d72168746f81f98ae3a1e8e0ca3554	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.29.1	\N	\N	0781718282
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2025-06-24 16:15:20.53235	36	EXECUTED	9:61b6d3d7a4c0e0024b0c839da283da0c	addColumn tableName=REALM		\N	4.29.1	\N	\N	0781718282
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-06-24 16:15:20.541861	37	EXECUTED	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	0781718282
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2025-06-24 16:15:20.549424	38	EXECUTED	9:a2b870802540cb3faa72098db5388af3	addColumn tableName=FED_USER_CONSENT		\N	4.29.1	\N	\N	0781718282
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2025-06-24 16:15:20.558765	39	EXECUTED	9:132a67499ba24bcc54fb5cbdcfe7e4c0	addColumn tableName=IDENTITY_PROVIDER		\N	4.29.1	\N	\N	0781718282
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-06-24 16:15:20.562772	40	MARK_RAN	9:938f894c032f5430f2b0fafb1a243462	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	4.29.1	\N	\N	0781718282
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-06-24 16:15:20.569448	41	MARK_RAN	9:845c332ff1874dc5d35974b0babf3006	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	4.29.1	\N	\N	0781718282
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2025-06-24 16:15:20.576565	42	EXECUTED	9:fc86359c079781adc577c5a217e4d04c	customChange		\N	4.29.1	\N	\N	0781718282
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-06-24 16:15:25.781101	43	EXECUTED	9:59a64800e3c0d09b825f8a3b444fa8f4	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	4.29.1	\N	\N	0781718282
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2025-06-24 16:15:25.79011	44	EXECUTED	9:d48d6da5c6ccf667807f633fe489ce88	addColumn tableName=USER_ENTITY		\N	4.29.1	\N	\N	0781718282
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-06-24 16:15:25.800663	45	EXECUTED	9:dde36f7973e80d71fceee683bc5d2951	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	4.29.1	\N	\N	0781718282
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-06-24 16:15:25.807642	46	EXECUTED	9:b855e9b0a406b34fa323235a0cf4f640	customChange		\N	4.29.1	\N	\N	0781718282
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-06-24 16:15:25.811409	47	MARK_RAN	9:51abbacd7b416c50c4421a8cabf7927e	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	4.29.1	\N	\N	0781718282
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-06-24 16:15:26.035717	48	EXECUTED	9:bdc99e567b3398bac83263d375aad143	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	4.29.1	\N	\N	0781718282
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-06-24 16:15:26.045527	49	EXECUTED	9:d198654156881c46bfba39abd7769e69	addColumn tableName=REALM		\N	4.29.1	\N	\N	0781718282
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2025-06-24 16:15:26.078352	50	EXECUTED	9:cfdd8736332ccdd72c5256ccb42335db	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	4.29.1	\N	\N	0781718282
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2025-06-24 16:15:26.503703	51	EXECUTED	9:7c84de3d9bd84d7f077607c1a4dcb714	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	4.29.1	\N	\N	0781718282
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2025-06-24 16:15:26.509827	52	EXECUTED	9:5a6bb36cbefb6a9d6928452c0852af2d	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	0781718282
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2025-06-24 16:15:26.514464	53	EXECUTED	9:8f23e334dbc59f82e0a328373ca6ced0	update tableName=REALM		\N	4.29.1	\N	\N	0781718282
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2025-06-24 16:15:26.519357	54	EXECUTED	9:9156214268f09d970cdf0e1564d866af	update tableName=CLIENT		\N	4.29.1	\N	\N	0781718282
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-06-24 16:15:26.530227	55	EXECUTED	9:db806613b1ed154826c02610b7dbdf74	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	4.29.1	\N	\N	0781718282
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-06-24 16:15:26.537467	56	EXECUTED	9:229a041fb72d5beac76bb94a5fa709de	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	4.29.1	\N	\N	0781718282
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-06-24 16:15:26.590851	57	EXECUTED	9:079899dade9c1e683f26b2aa9ca6ff04	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	4.29.1	\N	\N	0781718282
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-06-24 16:15:26.96468	58	EXECUTED	9:139b79bcbbfe903bb1c2d2a4dbf001d9	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	4.29.1	\N	\N	0781718282
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2025-06-24 16:15:26.987568	59	EXECUTED	9:b55738ad889860c625ba2bf483495a04	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	4.29.1	\N	\N	0781718282
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2025-06-24 16:15:26.996703	60	EXECUTED	9:e0057eac39aa8fc8e09ac6cfa4ae15fe	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	4.29.1	\N	\N	0781718282
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2025-06-24 16:15:27.008879	61	EXECUTED	9:42a33806f3a0443fe0e7feeec821326c	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	4.29.1	\N	\N	0781718282
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2025-06-24 16:15:27.016941	62	EXECUTED	9:9968206fca46eecc1f51db9c024bfe56	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	4.29.1	\N	\N	0781718282
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2025-06-24 16:15:27.025403	63	EXECUTED	9:92143a6daea0a3f3b8f598c97ce55c3d	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	4.29.1	\N	\N	0781718282
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2025-06-24 16:15:27.03083	64	EXECUTED	9:82bab26a27195d889fb0429003b18f40	update tableName=REQUIRED_ACTION_PROVIDER		\N	4.29.1	\N	\N	0781718282
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2025-06-24 16:15:27.035633	65	EXECUTED	9:e590c88ddc0b38b0ae4249bbfcb5abc3	update tableName=RESOURCE_SERVER_RESOURCE		\N	4.29.1	\N	\N	0781718282
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2025-06-24 16:15:27.080672	66	EXECUTED	9:5c1f475536118dbdc38d5d7977950cc0	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	4.29.1	\N	\N	0781718282
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2025-06-24 16:15:27.13022	67	EXECUTED	9:e7c9f5f9c4d67ccbbcc215440c718a17	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	4.29.1	\N	\N	0781718282
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2025-06-24 16:15:27.140826	68	EXECUTED	9:88e0bfdda924690d6f4e430c53447dd5	addColumn tableName=REALM		\N	4.29.1	\N	\N	0781718282
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2025-06-24 16:15:27.197999	69	EXECUTED	9:f53177f137e1c46b6a88c59ec1cb5218	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	4.29.1	\N	\N	0781718282
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2025-06-24 16:15:27.205813	70	EXECUTED	9:a74d33da4dc42a37ec27121580d1459f	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	4.29.1	\N	\N	0781718282
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2025-06-24 16:15:27.21338	71	EXECUTED	9:fd4ade7b90c3b67fae0bfcfcb42dfb5f	addColumn tableName=RESOURCE_SERVER		\N	4.29.1	\N	\N	0781718282
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-06-24 16:15:27.225115	72	EXECUTED	9:aa072ad090bbba210d8f18781b8cebf4	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	4.29.1	\N	\N	0781718282
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-06-24 16:15:27.236025	73	EXECUTED	9:1ae6be29bab7c2aa376f6983b932be37	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.29.1	\N	\N	0781718282
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-06-24 16:15:27.239408	74	MARK_RAN	9:14706f286953fc9a25286dbd8fb30d97	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.29.1	\N	\N	0781718282
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-06-24 16:15:27.265156	75	EXECUTED	9:2b9cc12779be32c5b40e2e67711a218b	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	4.29.1	\N	\N	0781718282
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-06-24 16:15:27.310035	76	EXECUTED	9:91fa186ce7a5af127a2d7a91ee083cc5	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.29.1	\N	\N	0781718282
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-06-24 16:15:27.319582	77	EXECUTED	9:6335e5c94e83a2639ccd68dd24e2e5ad	addColumn tableName=CLIENT		\N	4.29.1	\N	\N	0781718282
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-06-24 16:15:27.324018	78	MARK_RAN	9:6bdb5658951e028bfe16fa0a8228b530	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	4.29.1	\N	\N	0781718282
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-06-24 16:15:27.343616	79	EXECUTED	9:d5bc15a64117ccad481ce8792d4c608f	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	4.29.1	\N	\N	0781718282
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-06-24 16:15:27.347531	80	MARK_RAN	9:077cba51999515f4d3e7ad5619ab592c	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	4.29.1	\N	\N	0781718282
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-06-24 16:15:27.387777	81	EXECUTED	9:be969f08a163bf47c6b9e9ead8ac2afb	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	4.29.1	\N	\N	0781718282
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-06-24 16:15:27.391673	82	MARK_RAN	9:6d3bb4408ba5a72f39bd8a0b301ec6e3	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	0781718282
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-06-24 16:15:27.400846	83	EXECUTED	9:966bda61e46bebf3cc39518fbed52fa7	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	0781718282
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-06-24 16:15:27.403586	84	MARK_RAN	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	0781718282
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-06-24 16:15:27.438649	85	EXECUTED	9:7d93d602352a30c0c317e6a609b56599	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	4.29.1	\N	\N	0781718282
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2025-06-24 16:15:27.448232	86	EXECUTED	9:71c5969e6cdd8d7b6f47cebc86d37627	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	4.29.1	\N	\N	0781718282
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2025-06-24 16:15:27.458898	87	EXECUTED	9:a9ba7d47f065f041b7da856a81762021	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	4.29.1	\N	\N	0781718282
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2025-06-24 16:15:27.467239	88	EXECUTED	9:fffabce2bc01e1a8f5110d5278500065	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	4.29.1	\N	\N	0781718282
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-24 16:15:27.475618	89	EXECUTED	9:fa8a5b5445e3857f4b010bafb5009957	addColumn tableName=REALM; customChange		\N	4.29.1	\N	\N	0781718282
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-24 16:15:27.482909	90	EXECUTED	9:67ac3241df9a8582d591c5ed87125f39	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	4.29.1	\N	\N	0781718282
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-24 16:15:27.522243	91	EXECUTED	9:ad1194d66c937e3ffc82386c050ba089	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	0781718282
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-24 16:15:27.533455	92	EXECUTED	9:d9be619d94af5a2f5d07b9f003543b91	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	4.29.1	\N	\N	0781718282
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-24 16:15:27.536328	93	MARK_RAN	9:544d201116a0fcc5a5da0925fbbc3bde	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	4.29.1	\N	\N	0781718282
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-24 16:15:27.54545	94	EXECUTED	9:43c0c1055b6761b4b3e89de76d612ccf	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	4.29.1	\N	\N	0781718282
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-24 16:15:27.549205	95	MARK_RAN	9:8bd711fd0330f4fe980494ca43ab1139	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	4.29.1	\N	\N	0781718282
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-24 16:15:27.559603	96	EXECUTED	9:e07d2bc0970c348bb06fb63b1f82ddbf	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	4.29.1	\N	\N	0781718282
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-24 16:15:27.66516	97	EXECUTED	9:24fb8611e97f29989bea412aa38d12b7	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	0781718282
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-24 16:15:27.667962	98	MARK_RAN	9:259f89014ce2506ee84740cbf7163aa7	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	0781718282
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-24 16:15:27.688608	99	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	0781718282
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-24 16:15:27.733877	100	EXECUTED	9:60ca84a0f8c94ec8c3504a5a3bc88ee8	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	0781718282
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-24 16:15:27.738219	101	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	0781718282
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-24 16:15:27.780988	102	EXECUTED	9:0b305d8d1277f3a89a0a53a659ad274c	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	4.29.1	\N	\N	0781718282
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-24 16:15:27.78839	103	EXECUTED	9:2c374ad2cdfe20e2905a84c8fac48460	customChange		\N	4.29.1	\N	\N	0781718282
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2025-06-24 16:15:27.797593	104	EXECUTED	9:47a760639ac597360a8219f5b768b4de	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	4.29.1	\N	\N	0781718282
17.0.0-9562	keycloak	META-INF/jpa-changelog-17.0.0.xml	2025-06-24 16:15:27.838906	105	EXECUTED	9:a6272f0576727dd8cad2522335f5d99e	createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY		\N	4.29.1	\N	\N	0781718282
18.0.0-10625-IDX_ADMIN_EVENT_TIME	keycloak	META-INF/jpa-changelog-18.0.0.xml	2025-06-24 16:15:27.879938	106	EXECUTED	9:015479dbd691d9cc8669282f4828c41d	createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY		\N	4.29.1	\N	\N	0781718282
18.0.15-30992-index-consent	keycloak	META-INF/jpa-changelog-18.0.15.xml	2025-06-24 16:15:27.925334	107	EXECUTED	9:80071ede7a05604b1f4906f3bf3b00f0	createIndex indexName=IDX_USCONSENT_SCOPE_ID, tableName=USER_CONSENT_CLIENT_SCOPE		\N	4.29.1	\N	\N	0781718282
19.0.0-10135	keycloak	META-INF/jpa-changelog-19.0.0.xml	2025-06-24 16:15:27.931612	108	EXECUTED	9:9518e495fdd22f78ad6425cc30630221	customChange		\N	4.29.1	\N	\N	0781718282
20.0.0-12964-supported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-06-24 16:15:27.973659	109	EXECUTED	9:e5f243877199fd96bcc842f27a1656ac	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.29.1	\N	\N	0781718282
20.0.0-12964-unsupported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-06-24 16:15:27.978086	110	MARK_RAN	9:1a6fcaa85e20bdeae0a9ce49b41946a5	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.29.1	\N	\N	0781718282
client-attributes-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-06-24 16:15:27.990032	111	EXECUTED	9:3f332e13e90739ed0c35b0b25b7822ca	addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	0781718282
21.0.2-17277	keycloak	META-INF/jpa-changelog-21.0.2.xml	2025-06-24 16:15:27.996131	112	EXECUTED	9:7ee1f7a3fb8f5588f171fb9a6ab623c0	customChange		\N	4.29.1	\N	\N	0781718282
21.1.0-19404	keycloak	META-INF/jpa-changelog-21.1.0.xml	2025-06-24 16:15:28.010743	113	EXECUTED	9:3d7e830b52f33676b9d64f7f2b2ea634	modifyDataType columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=LOGIC, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=POLICY_ENFORCE_MODE, tableName=RESOURCE_SERVER		\N	4.29.1	\N	\N	0781718282
21.1.0-19404-2	keycloak	META-INF/jpa-changelog-21.1.0.xml	2025-06-24 16:15:28.016719	114	MARK_RAN	9:627d032e3ef2c06c0e1f73d2ae25c26c	addColumn tableName=RESOURCE_SERVER_POLICY; update tableName=RESOURCE_SERVER_POLICY; dropColumn columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; renameColumn newColumnName=DECISION_STRATEGY, oldColumnName=DECISION_STRATEGY_NEW, tabl...		\N	4.29.1	\N	\N	0781718282
22.0.0-17484-updated	keycloak	META-INF/jpa-changelog-22.0.0.xml	2025-06-24 16:15:28.024741	115	EXECUTED	9:90af0bfd30cafc17b9f4d6eccd92b8b3	customChange		\N	4.29.1	\N	\N	0781718282
22.0.5-24031	keycloak	META-INF/jpa-changelog-22.0.0.xml	2025-06-24 16:15:28.028661	116	MARK_RAN	9:a60d2d7b315ec2d3eba9e2f145f9df28	customChange		\N	4.29.1	\N	\N	0781718282
23.0.0-12062	keycloak	META-INF/jpa-changelog-23.0.0.xml	2025-06-24 16:15:28.037989	117	EXECUTED	9:2168fbe728fec46ae9baf15bf80927b8	addColumn tableName=COMPONENT_CONFIG; update tableName=COMPONENT_CONFIG; dropColumn columnName=VALUE, tableName=COMPONENT_CONFIG; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=COMPONENT_CONFIG		\N	4.29.1	\N	\N	0781718282
23.0.0-17258	keycloak	META-INF/jpa-changelog-23.0.0.xml	2025-06-24 16:15:28.044081	118	EXECUTED	9:36506d679a83bbfda85a27ea1864dca8	addColumn tableName=EVENT_ENTITY		\N	4.29.1	\N	\N	0781718282
24.0.0-9758	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-06-24 16:15:28.185858	119	EXECUTED	9:502c557a5189f600f0f445a9b49ebbce	addColumn tableName=USER_ATTRIBUTE; addColumn tableName=FED_USER_ATTRIBUTE; createIndex indexName=USER_ATTR_LONG_VALUES, tableName=USER_ATTRIBUTE; createIndex indexName=FED_USER_ATTR_LONG_VALUES, tableName=FED_USER_ATTRIBUTE; createIndex indexName...		\N	4.29.1	\N	\N	0781718282
24.0.0-9758-2	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-06-24 16:15:28.192529	120	EXECUTED	9:bf0fdee10afdf597a987adbf291db7b2	customChange		\N	4.29.1	\N	\N	0781718282
24.0.0-26618-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-06-24 16:15:28.200325	121	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	0781718282
24.0.0-26618-reindex	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-06-24 16:15:28.240088	122	EXECUTED	9:08707c0f0db1cef6b352db03a60edc7f	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	0781718282
24.0.2-27228	keycloak	META-INF/jpa-changelog-24.0.2.xml	2025-06-24 16:15:28.247543	123	EXECUTED	9:eaee11f6b8aa25d2cc6a84fb86fc6238	customChange		\N	4.29.1	\N	\N	0781718282
24.0.2-27967-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.2.xml	2025-06-24 16:15:28.251988	124	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	0781718282
24.0.2-27967-reindex	keycloak	META-INF/jpa-changelog-24.0.2.xml	2025-06-24 16:15:28.256272	125	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	0781718282
25.0.0-28265-tables	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-24 16:15:28.266579	126	EXECUTED	9:deda2df035df23388af95bbd36c17cef	addColumn tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_CLIENT_SESSION		\N	4.29.1	\N	\N	0781718282
25.0.0-28265-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-24 16:15:28.304102	127	EXECUTED	9:3e96709818458ae49f3c679ae58d263a	createIndex indexName=IDX_OFFLINE_USS_BY_LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	0781718282
25.0.0-28265-index-cleanup-uss-createdon	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-24 16:15:28.541222	128	EXECUTED	9:78ab4fc129ed5e8265dbcc3485fba92f	dropIndex indexName=IDX_OFFLINE_USS_CREATEDON, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	0781718282
25.0.0-28265-index-cleanup-uss-preload	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-24 16:15:28.724107	129	EXECUTED	9:de5f7c1f7e10994ed8b62e621d20eaab	dropIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	0781718282
25.0.0-28265-index-cleanup-uss-by-usersess	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-24 16:15:28.897468	130	EXECUTED	9:6eee220d024e38e89c799417ec33667f	dropIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	0781718282
25.0.0-28265-index-cleanup-css-preload	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-24 16:15:29.084155	131	EXECUTED	9:5411d2fb2891d3e8d63ddb55dfa3c0c9	dropIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION		\N	4.29.1	\N	\N	0781718282
25.0.0-28265-index-2-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-24 16:15:29.087189	132	MARK_RAN	9:b7ef76036d3126bb83c2423bf4d449d6	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	0781718282
25.0.0-28265-index-2-not-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-24 16:15:29.136139	133	EXECUTED	9:23396cf51ab8bc1ae6f0cac7f9f6fcf7	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	0781718282
25.0.0-org	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-24 16:15:29.151892	134	EXECUTED	9:5c859965c2c9b9c72136c360649af157	createTable tableName=ORG; addUniqueConstraint constraintName=UK_ORG_NAME, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_GROUP, tableName=ORG; createTable tableName=ORG_DOMAIN		\N	4.29.1	\N	\N	0781718282
unique-consentuser	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-24 16:15:29.165147	135	EXECUTED	9:5857626a2ea8767e9a6c66bf3a2cb32f	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.29.1	\N	\N	0781718282
unique-consentuser-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-24 16:15:29.168662	136	MARK_RAN	9:b79478aad5adaa1bc428e31563f55e8e	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.29.1	\N	\N	0781718282
25.0.0-28861-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-24 16:15:29.261559	137	EXECUTED	9:b9acb58ac958d9ada0fe12a5d4794ab1	createIndex indexName=IDX_PERM_TICKET_REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; createIndex indexName=IDX_PERM_TICKET_OWNER, tableName=RESOURCE_SERVER_PERM_TICKET		\N	4.29.1	\N	\N	0781718282
26.0.0-org-alias	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-06-24 16:15:29.272602	138	EXECUTED	9:6ef7d63e4412b3c2d66ed179159886a4	addColumn tableName=ORG; update tableName=ORG; addNotNullConstraint columnName=ALIAS, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_ALIAS, tableName=ORG		\N	4.29.1	\N	\N	0781718282
26.0.0-org-group	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-06-24 16:15:29.283004	139	EXECUTED	9:da8e8087d80ef2ace4f89d8c5b9ca223	addColumn tableName=KEYCLOAK_GROUP; update tableName=KEYCLOAK_GROUP; addNotNullConstraint columnName=TYPE, tableName=KEYCLOAK_GROUP; customChange		\N	4.29.1	\N	\N	0781718282
26.0.0-org-indexes	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-06-24 16:15:29.324623	140	EXECUTED	9:79b05dcd610a8c7f25ec05135eec0857	createIndex indexName=IDX_ORG_DOMAIN_ORG_ID, tableName=ORG_DOMAIN		\N	4.29.1	\N	\N	0781718282
26.0.0-org-group-membership	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-06-24 16:15:29.33582	141	EXECUTED	9:a6ace2ce583a421d89b01ba2a28dc2d4	addColumn tableName=USER_GROUP_MEMBERSHIP; update tableName=USER_GROUP_MEMBERSHIP; addNotNullConstraint columnName=MEMBERSHIP_TYPE, tableName=USER_GROUP_MEMBERSHIP		\N	4.29.1	\N	\N	0781718282
31296-persist-revoked-access-tokens	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-06-24 16:15:29.345258	142	EXECUTED	9:64ef94489d42a358e8304b0e245f0ed4	createTable tableName=REVOKED_TOKEN; addPrimaryKey constraintName=CONSTRAINT_RT, tableName=REVOKED_TOKEN		\N	4.29.1	\N	\N	0781718282
31725-index-persist-revoked-access-tokens	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-06-24 16:15:29.384222	143	EXECUTED	9:b994246ec2bf7c94da881e1d28782c7b	createIndex indexName=IDX_REV_TOKEN_ON_EXPIRE, tableName=REVOKED_TOKEN		\N	4.29.1	\N	\N	0781718282
26.0.0-idps-for-login	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-06-24 16:15:29.462983	144	EXECUTED	9:51f5fffadf986983d4bd59582c6c1604	addColumn tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_REALM_ORG, tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_FOR_LOGIN, tableName=IDENTITY_PROVIDER; customChange		\N	4.29.1	\N	\N	0781718282
26.0.0-32583-drop-redundant-index-on-client-session	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-06-24 16:15:29.627176	145	EXECUTED	9:24972d83bf27317a055d234187bb4af9	dropIndex indexName=IDX_US_SESS_ID_ON_CL_SESS, tableName=OFFLINE_CLIENT_SESSION		\N	4.29.1	\N	\N	0781718282
26.0.0.32582-remove-tables-user-session-user-session-note-and-client-session	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-06-24 16:15:29.642021	146	EXECUTED	9:febdc0f47f2ed241c59e60f58c3ceea5	dropTable tableName=CLIENT_SESSION_ROLE; dropTable tableName=CLIENT_SESSION_NOTE; dropTable tableName=CLIENT_SESSION_PROT_MAPPER; dropTable tableName=CLIENT_SESSION_AUTH_STATUS; dropTable tableName=CLIENT_USER_SESSION_NOTE; dropTable tableName=CLI...		\N	4.29.1	\N	\N	0781718282
26.0.0-33201-org-redirect-url	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-06-24 16:15:29.649778	147	EXECUTED	9:4d0e22b0ac68ebe9794fa9cb752ea660	addColumn tableName=ORG		\N	4.29.1	\N	\N	0781718282
29399-jdbc-ping-default	keycloak	META-INF/jpa-changelog-26.1.0.xml	2025-06-24 16:15:29.659195	148	EXECUTED	9:007dbe99d7203fca403b89d4edfdf21e	createTable tableName=JGROUPS_PING; addPrimaryKey constraintName=CONSTRAINT_JGROUPS_PING, tableName=JGROUPS_PING		\N	4.29.1	\N	\N	0781718282
26.1.0-34013	keycloak	META-INF/jpa-changelog-26.1.0.xml	2025-06-24 16:15:29.687902	149	EXECUTED	9:e6b686a15759aef99a6d758a5c4c6a26	addColumn tableName=ADMIN_EVENT_ENTITY		\N	4.29.1	\N	\N	0781718282
26.1.0-34380	keycloak	META-INF/jpa-changelog-26.1.0.xml	2025-06-24 16:15:29.695671	150	EXECUTED	9:ac8b9edb7c2b6c17a1c7a11fcf5ccf01	dropTable tableName=USERNAME_LOGIN_FAILURE		\N	4.29.1	\N	\N	0781718282
26.2.0-36750	keycloak	META-INF/jpa-changelog-26.2.0.xml	2025-06-24 16:15:29.705825	151	EXECUTED	9:b49ce951c22f7eb16480ff085640a33a	createTable tableName=SERVER_CONFIG		\N	4.29.1	\N	\N	0781718282
26.2.0-26106	keycloak	META-INF/jpa-changelog-26.2.0.xml	2025-06-24 16:15:29.714339	152	EXECUTED	9:b5877d5dab7d10ff3a9d209d7beb6680	addColumn tableName=CREDENTIAL		\N	4.29.1	\N	\N	0781718282
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
9427ab20-f0da-41bd-8ffd-6c4fffb2afec	1b8b33fa-d3e9-4ce6-a388-6abc010589e9	f
9427ab20-f0da-41bd-8ffd-6c4fffb2afec	b648708b-4045-4cf5-9bc2-3e4b2936100f	t
9427ab20-f0da-41bd-8ffd-6c4fffb2afec	049a264b-466a-45dc-b92f-df53fbc6192c	t
9427ab20-f0da-41bd-8ffd-6c4fffb2afec	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72	t
9427ab20-f0da-41bd-8ffd-6c4fffb2afec	73c1a3d6-4422-4ffc-8e90-9ebf10d8de52	t
9427ab20-f0da-41bd-8ffd-6c4fffb2afec	c1e8b245-1801-4f18-bcd6-d0134ca5ff5f	f
9427ab20-f0da-41bd-8ffd-6c4fffb2afec	c72c3f5e-4bd5-47e0-aa95-7965f2aa68ba	f
9427ab20-f0da-41bd-8ffd-6c4fffb2afec	083216b5-3aca-4685-b461-e835aff2acd7	t
9427ab20-f0da-41bd-8ffd-6c4fffb2afec	1b558ef7-32d7-4df6-af3f-25ca4089b195	t
9427ab20-f0da-41bd-8ffd-6c4fffb2afec	d7d2f37c-0430-498e-9f5f-91135e10d64e	f
9427ab20-f0da-41bd-8ffd-6c4fffb2afec	52c17ef6-dd48-457f-b27d-047c0bb84708	t
9427ab20-f0da-41bd-8ffd-6c4fffb2afec	02ceb4d8-fe1c-423a-903f-5e4fa5bd2d6d	t
9427ab20-f0da-41bd-8ffd-6c4fffb2afec	d0179dba-d8ad-4d2a-9231-075f2e6530c8	f
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	34aa2dce-16c8-457d-9178-bb836e027ca2	f
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2977881a-44c7-40ba-aa11-afb0a05ec0b2	t
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	8c468075-525e-4ab3-94ec-ba4dc437c24f	t
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	178dac49-f258-4a20-a227-baca55f97d8d	t
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	b9c6ce23-7173-41dd-be46-cdfb74fec18a	t
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	1ed0d4c4-0720-4e69-be21-091241d3c574	f
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	49ab1a06-38f4-4c32-868e-48b61022c00f	f
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	5b0a8700-85e8-46b9-a764-6cd2f85d8846	t
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	ef14b883-04bf-4557-be1a-231b99162857	t
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	813c8c55-74e0-494f-9682-23d026340f42	f
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	fa609b0e-925f-4251-a437-291fdf9d71a1	t
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	51061315-4b70-49de-b605-55a40d6ab93f	t
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

COPY public.keycloak_group (id, name, parent_group, realm_id, type) FROM stdin;
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
3a60f580-118b-4313-9862-5e2ea6468ae3	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	f	${role_default-roles}	default-roles-master	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	\N	\N
43aa79a0-a270-4ff7-8ebc-886c82c232ff	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	f	${role_create-realm}	create-realm	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	\N	\N
e4bc0604-3995-4e2f-a040-0f0a87d89eef	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	f	${role_admin}	admin	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	\N	\N
5c595a70-9c94-4dfc-ac0d-13405acd86d8	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	t	${role_create-client}	create-client	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	\N
9e1833a4-74ef-41c0-a16a-f39d15d87bb8	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	t	${role_view-realm}	view-realm	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	\N
3b4e72e2-d7a3-415d-93e6-daf27b8ba77e	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	t	${role_view-users}	view-users	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	\N
429d2b87-c91d-4529-a339-43ed4f1190e6	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	t	${role_view-clients}	view-clients	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	\N
d4dd2e70-f84f-4462-a986-157efe8ff006	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	t	${role_view-events}	view-events	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	\N
b36157c0-3adb-45ae-87ec-23986c5a5d12	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	t	${role_view-identity-providers}	view-identity-providers	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	\N
a0c7e81f-9d87-42d1-ae08-ced0ea36a956	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	t	${role_view-authorization}	view-authorization	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	\N
c5977078-05ed-4923-9525-12aa1026adbd	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	t	${role_manage-realm}	manage-realm	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	\N
f3a2080d-0070-4de4-aae6-3891c5dc259e	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	t	${role_manage-users}	manage-users	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	\N
69e494dd-7d92-447d-a9e1-719f6436b781	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	t	${role_manage-clients}	manage-clients	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	\N
be5b64b7-105e-445a-9a8b-145032bc3b58	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	t	${role_manage-events}	manage-events	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	\N
389c6530-1195-4cbd-9775-e6a9c386c5cc	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	t	${role_manage-identity-providers}	manage-identity-providers	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	\N
1bdf67d2-3c0a-42e1-aba1-01819e0eb266	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	t	${role_manage-authorization}	manage-authorization	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	\N
60a7d234-81e1-44bc-ad02-202dd4fb5d10	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	t	${role_query-users}	query-users	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	\N
989e71ec-ae67-4be3-abd9-dbab1a1fa7ea	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	t	${role_query-clients}	query-clients	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	\N
0c444e00-9b67-457f-93d1-368d8567023e	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	t	${role_query-realms}	query-realms	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	\N
1c5ca66c-929c-4383-9d7e-23a379b211f4	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	t	${role_query-groups}	query-groups	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	\N
25b80856-7e1a-439c-8573-834d4b540b6c	ac19a97d-4491-41af-821a-8ed32e659238	t	${role_view-profile}	view-profile	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	ac19a97d-4491-41af-821a-8ed32e659238	\N
d064310e-a85d-4180-a449-fb2b57cd41d3	ac19a97d-4491-41af-821a-8ed32e659238	t	${role_manage-account}	manage-account	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	ac19a97d-4491-41af-821a-8ed32e659238	\N
51ae94f8-5d79-48cf-b6f7-1effe5cb61fe	ac19a97d-4491-41af-821a-8ed32e659238	t	${role_manage-account-links}	manage-account-links	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	ac19a97d-4491-41af-821a-8ed32e659238	\N
480a2de7-2af0-4af4-9f4b-ef9eb9dab8a5	ac19a97d-4491-41af-821a-8ed32e659238	t	${role_view-applications}	view-applications	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	ac19a97d-4491-41af-821a-8ed32e659238	\N
71595598-747d-4c05-adc2-6a65a2edaba3	ac19a97d-4491-41af-821a-8ed32e659238	t	${role_view-consent}	view-consent	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	ac19a97d-4491-41af-821a-8ed32e659238	\N
70b37896-b52e-4898-9195-16f6af7c46e1	ac19a97d-4491-41af-821a-8ed32e659238	t	${role_manage-consent}	manage-consent	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	ac19a97d-4491-41af-821a-8ed32e659238	\N
79b64669-e2f1-4bf3-a880-23403d52a92c	ac19a97d-4491-41af-821a-8ed32e659238	t	${role_view-groups}	view-groups	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	ac19a97d-4491-41af-821a-8ed32e659238	\N
eccea425-7107-4df1-acdc-95144e9e7b1b	ac19a97d-4491-41af-821a-8ed32e659238	t	${role_delete-account}	delete-account	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	ac19a97d-4491-41af-821a-8ed32e659238	\N
17477d77-d90c-469d-967e-26fc1f6c8782	04149cb0-f7b0-43c2-b5d6-c2ec965fd2d8	t	${role_read-token}	read-token	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	04149cb0-f7b0-43c2-b5d6-c2ec965fd2d8	\N
888984ca-844b-431e-811f-ab45a3f9f18b	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	t	${role_impersonation}	impersonation	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	\N
eaae3760-7633-468b-aa11-def248b30acb	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	f	${role_offline-access}	offline_access	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	\N	\N
27b438e3-336a-4f52-9ebe-272dc4dca2c9	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	f	${role_uma_authorization}	uma_authorization	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	\N	\N
32d78998-b4a3-4358-9f41-9fb89659de0b	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	f	${role_default-roles}	default-roles-nextjs-dashboard	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	\N	\N
f9081211-adf8-4217-8c9c-e2bb15e79457	20a6e660-7f69-4043-a157-2d2f03b71f01	t	${role_create-client}	create-client	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	20a6e660-7f69-4043-a157-2d2f03b71f01	\N
856585b5-b4a5-4605-be67-8b1010e1306e	20a6e660-7f69-4043-a157-2d2f03b71f01	t	${role_view-realm}	view-realm	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	20a6e660-7f69-4043-a157-2d2f03b71f01	\N
b78df878-9033-4a71-bbe7-aa8c57fb04e6	20a6e660-7f69-4043-a157-2d2f03b71f01	t	${role_view-users}	view-users	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	20a6e660-7f69-4043-a157-2d2f03b71f01	\N
4c0df749-b572-482d-b7f3-4a1c84467895	20a6e660-7f69-4043-a157-2d2f03b71f01	t	${role_view-clients}	view-clients	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	20a6e660-7f69-4043-a157-2d2f03b71f01	\N
3f64a199-df0a-4634-97e4-4cbab1e71d1c	20a6e660-7f69-4043-a157-2d2f03b71f01	t	${role_view-events}	view-events	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	20a6e660-7f69-4043-a157-2d2f03b71f01	\N
00f9037b-1280-4064-9b3c-cd671231325f	20a6e660-7f69-4043-a157-2d2f03b71f01	t	${role_view-identity-providers}	view-identity-providers	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	20a6e660-7f69-4043-a157-2d2f03b71f01	\N
b4687db6-8738-423a-a44b-cb312f06f8ee	20a6e660-7f69-4043-a157-2d2f03b71f01	t	${role_view-authorization}	view-authorization	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	20a6e660-7f69-4043-a157-2d2f03b71f01	\N
66beb2b9-0760-4e01-b240-66345c8789bf	20a6e660-7f69-4043-a157-2d2f03b71f01	t	${role_manage-realm}	manage-realm	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	20a6e660-7f69-4043-a157-2d2f03b71f01	\N
688954e3-6c54-4dc9-ace2-42ac946b468b	20a6e660-7f69-4043-a157-2d2f03b71f01	t	${role_manage-users}	manage-users	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	20a6e660-7f69-4043-a157-2d2f03b71f01	\N
556ba6df-29fc-4547-b12b-1b451f5573b1	20a6e660-7f69-4043-a157-2d2f03b71f01	t	${role_manage-clients}	manage-clients	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	20a6e660-7f69-4043-a157-2d2f03b71f01	\N
abe4a23e-5964-4c9a-9007-1ad42921df6f	20a6e660-7f69-4043-a157-2d2f03b71f01	t	${role_manage-events}	manage-events	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	20a6e660-7f69-4043-a157-2d2f03b71f01	\N
148ab9a3-659b-4857-aed2-a73f8abf8bd2	20a6e660-7f69-4043-a157-2d2f03b71f01	t	${role_manage-identity-providers}	manage-identity-providers	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	20a6e660-7f69-4043-a157-2d2f03b71f01	\N
caf4207e-2a25-4e56-a4e4-2e7fb0eea705	20a6e660-7f69-4043-a157-2d2f03b71f01	t	${role_manage-authorization}	manage-authorization	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	20a6e660-7f69-4043-a157-2d2f03b71f01	\N
c361f50e-361a-4498-90e4-ef3928d784ae	20a6e660-7f69-4043-a157-2d2f03b71f01	t	${role_query-users}	query-users	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	20a6e660-7f69-4043-a157-2d2f03b71f01	\N
e4dc275f-5988-479b-aa5d-bf78e0ac9d57	20a6e660-7f69-4043-a157-2d2f03b71f01	t	${role_query-clients}	query-clients	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	20a6e660-7f69-4043-a157-2d2f03b71f01	\N
59a993d5-1261-4300-8ffe-5e4642fcc3e7	20a6e660-7f69-4043-a157-2d2f03b71f01	t	${role_query-realms}	query-realms	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	20a6e660-7f69-4043-a157-2d2f03b71f01	\N
47c71bd8-59ea-423c-929f-cf7f9603b9ac	20a6e660-7f69-4043-a157-2d2f03b71f01	t	${role_query-groups}	query-groups	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	20a6e660-7f69-4043-a157-2d2f03b71f01	\N
039ef22d-8b23-4b53-b9a3-5cc4c045106a	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_realm-admin}	realm-admin	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
8454fee2-3bc4-489b-b5d5-506b198e5d9b	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_create-client}	create-client	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
d39a71e7-af44-44ab-acbe-a8b775bb7cc0	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_view-realm}	view-realm	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
60b24f76-8155-4148-8393-6e901d8cbcf9	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_view-users}	view-users	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
8001e5fe-28ba-4edd-8965-aac813d72ac0	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_view-clients}	view-clients	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
30aa02d9-cb2b-4296-acb5-cb793f6ce168	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_view-events}	view-events	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
99004025-3a53-4034-af27-f6f4f43c9b6c	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_view-identity-providers}	view-identity-providers	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
94241f64-7db6-42a3-9a50-203be4be51e7	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_view-authorization}	view-authorization	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
a005ca50-933e-4db6-9ea2-347884029741	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_manage-realm}	manage-realm	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
15800581-6ec2-42f0-9c41-2f2729999d4f	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_manage-users}	manage-users	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
972c32be-9cd3-4007-bae1-55d889a17e95	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_manage-clients}	manage-clients	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
f9f8d363-c92f-4507-bdeb-86502debb23e	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_manage-events}	manage-events	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
e87a45b9-e1ed-414c-97dc-6457c75a7dbe	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_manage-identity-providers}	manage-identity-providers	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
2a623913-f224-449c-96be-bde34c5c38df	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_manage-authorization}	manage-authorization	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
0f70a87a-27f6-474e-a9db-6e9e31e5c378	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_query-users}	query-users	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
edb6a370-faf8-4585-b4b4-11bf0e3686f6	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_query-clients}	query-clients	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
1b645b0a-a9e1-4019-857e-29e3b2be12bd	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_query-realms}	query-realms	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
e8d9c21e-8eb4-4d30-a313-db934f7f228a	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_query-groups}	query-groups	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
09ddac52-762c-464b-9011-a1cff339f646	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	t	${role_view-profile}	view-profile	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	\N
e5ca7bde-db56-490d-afe1-25f4d5636935	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	t	${role_manage-account}	manage-account	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	\N
d61213bf-dbdb-4c2d-a4eb-5a1492f24d62	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	t	${role_manage-account-links}	manage-account-links	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	\N
e1f56a64-6997-4035-ac4a-a99a7bdaf927	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	t	${role_view-applications}	view-applications	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	\N
2e9319f4-086d-43e7-94a9-022e66ce35e3	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	t	${role_view-consent}	view-consent	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	\N
fafef884-34e4-4dc5-8796-2c56aaa97fe0	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	t	${role_manage-consent}	manage-consent	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	\N
288cb142-db49-44cc-bd8f-cfd2131bd52b	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	t	${role_view-groups}	view-groups	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	\N
c64cd10f-adca-4811-8b5c-87163ed080d7	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	t	${role_delete-account}	delete-account	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	\N
009e89f7-c032-4775-a630-fde9b44cf5f2	20a6e660-7f69-4043-a157-2d2f03b71f01	t	${role_impersonation}	impersonation	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	20a6e660-7f69-4043-a157-2d2f03b71f01	\N
3647a876-c772-4463-a922-b8924d0c084d	2aceca6f-245d-4ffe-80a0-efc46198a4f2	t	${role_impersonation}	impersonation	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	2aceca6f-245d-4ffe-80a0-efc46198a4f2	\N
f6f5b69f-434a-4aa7-ba9c-3694c695d9b2	ea8fbaa3-b5f1-4548-acef-7f4622c53980	t	${role_read-token}	read-token	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	ea8fbaa3-b5f1-4548-acef-7f4622c53980	\N
5926e4b6-ce4f-44c7-b71f-3ec7ffb9cdd6	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	f	${role_offline-access}	offline_access	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	\N	\N
38a16972-2598-4dd5-b2de-5a108ce9c748	4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	t	Role for Dashboard Admins in Parkigo client	dashboard_admin	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	\N
1fbe4fc6-50aa-45e4-adbf-f7b73d0e1836	4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	t	Role for Dashboard Owners in Parkigo client	dashboard_owner	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	\N
f509302a-4f0d-488f-ac8e-3b2858c5de9f	4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	t	Role for Dashboard Renters in Parkigo client	dashboard_renter	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	\N
d42a8b82-d043-4511-b13a-f745401e871d	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	f	${role_uma_authorization}	uma_authorization	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	\N	\N
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.migration_model (id, version, update_time) FROM stdin;
e2icx	26.2.5	1750781731
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id, version) FROM stdin;
6702af06-41bf-4603-ab22-114e0085b3f6	4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	0	1750851132	{"authMethod":"openid-connect","redirectUri":"http://localhost:3000/api/auth/callback/keycloak","notes":{"clientId":"4f3a4304-78e2-4cc9-abbc-fe777a4a24ed","iss":"http://localhost:8081/realms/nextjs-dashboard","startedAt":"1750851132","response_type":"code","level-of-authentication":"-1","code_challenge_method":"S256","scope":"openid email profile","SSO_AUTH":"true","userSessionStartedAt":"1750850810","redirect_uri":"http://localhost:3000/api/auth/callback/keycloak","state":"1IVYtMLrsZSYM5lN6KfWEh6_rZKOHZ-90sV8rrIyF3M","code_challenge":"3qS0hIVYs5qXoIyaaQiOwUswSPlYjFizYrhdk_jbehQ"}}	local	local	0
d56b4774-e58a-494e-8f3d-040c5a198277	4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	0	1751032651	{"authMethod":"openid-connect","redirectUri":"http://localhost:3000/api/auth/callback/keycloak","notes":{"clientId":"4f3a4304-78e2-4cc9-abbc-fe777a4a24ed","scope":"openid email profile","userSessionStartedAt":"1751032647","iss":"http://localhost:8081/realms/nextjs-dashboard","startedAt":"1751032648","response_type":"code","level-of-authentication":"-1","code_challenge_method":"S256","redirect_uri":"http://localhost:3000/api/auth/callback/keycloak","state":"FkSh0o5HacS26YY-GTSpXCudiMqr2niF_7KCnggnZdY","code_challenge":"4P7YRHlzpxB8-gZ_6KtP5-QX0qeKXu7jgVEA_2XQ4uc"}}	local	local	1
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh, broker_session_id, version) FROM stdin;
d56b4774-e58a-494e-8f3d-040c5a198277	e4d137a8-ca21-4bd5-80dc-69cee3432bdb	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	1751032647	0	{"ipAddress":"172.18.0.1","authMethod":"openid-connect","rememberMe":false,"started":0,"notes":{"KC_DEVICE_NOTE":"eyJpcEFkZHJlc3MiOiIxNzIuMTguMC4xIiwib3MiOiJXaW5kb3dzIiwib3NWZXJzaW9uIjoiMTAiLCJicm93c2VyIjoiRmlyZWZveC8xMzkuMCIsImRldmljZSI6Ik90aGVyIiwibGFzdEFjY2VzcyI6MCwibW9iaWxlIjpmYWxzZX0=","AUTH_TIME":"1751032648","authenticators-completed":"{\\"04ff2ebf-d912-4a6a-b448-e0a21434c3d7\\":1751032647}"},"state":"LOGGED_IN"}	1751032651	\N	1
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
96661c0c-9ced-4c4a-aad2-2156fb55c759	audience resolve	openid-connect	oidc-audience-resolve-mapper	d71f7760-85bc-44da-bf2b-7f44d17e580b	\N
8b2734a8-ef71-4b4c-8e19-f606aeed6bdd	locale	openid-connect	oidc-usermodel-attribute-mapper	bd065e4a-130c-45f2-8c11-674e99fb51fb	\N
b6847ba9-baef-4927-9980-eb4f04719524	role list	saml	saml-role-list-mapper	\N	b648708b-4045-4cf5-9bc2-3e4b2936100f
6ac88575-c050-4d6f-ad8d-ee0a94c0f80f	organization	saml	saml-organization-membership-mapper	\N	049a264b-466a-45dc-b92f-df53fbc6192c
3cfe56a4-8d7e-46ec-b8bf-d1343dbc0289	full name	openid-connect	oidc-full-name-mapper	\N	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72
ae8171b9-d14f-4f07-b914-9df970110126	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72
194b7405-0884-4637-8bb7-ae66af3015d5	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72
5c5cad44-ce80-49ac-98b0-bfb6ff4045fa	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72
8ba4e1fc-837b-4a36-9532-584174013244	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72
3bbbd110-ce51-4c04-939d-6d10f9de7033	username	openid-connect	oidc-usermodel-attribute-mapper	\N	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72
747b597d-a0cb-40a2-b742-0fa98c7fff6e	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72
403390d1-2f94-4328-8b24-5306ede5b7fc	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72
feb11978-72fa-431d-9e4f-6db654011607	website	openid-connect	oidc-usermodel-attribute-mapper	\N	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72
209b6b65-9ec5-409e-a906-254759c42e1f	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72
a1a2de6e-9fa7-4351-9881-f36bcafc0fa0	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72
c0ff9053-29f2-48b7-8b7e-ae9efd7a0747	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72
e4c83ef5-9dd9-48de-ac68-2ec10ddaa52b	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72
2535f545-1983-444c-9d4e-49f248788832	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	6bc23c09-d36b-4291-b1dc-4d1a46fbbb72
94ed27a0-dbc7-4be3-b329-7ae3d1c5e716	email	openid-connect	oidc-usermodel-attribute-mapper	\N	73c1a3d6-4422-4ffc-8e90-9ebf10d8de52
c22dce6f-6f97-4c95-8864-f55cd95c8df6	email verified	openid-connect	oidc-usermodel-property-mapper	\N	73c1a3d6-4422-4ffc-8e90-9ebf10d8de52
b1b8dec9-1e03-43fc-8055-f2b76e0fc5b2	address	openid-connect	oidc-address-mapper	\N	c1e8b245-1801-4f18-bcd6-d0134ca5ff5f
0d4c2dbf-2455-4471-8515-ab3698cbf8b0	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	c72c3f5e-4bd5-47e0-aa95-7965f2aa68ba
07d34669-5cb9-4f88-be0f-7f33ea9ef8ef	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	c72c3f5e-4bd5-47e0-aa95-7965f2aa68ba
27c075ae-21ce-4983-b8ad-57fbc4e208c1	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	083216b5-3aca-4685-b461-e835aff2acd7
07117a4e-065d-426b-add2-86c321174fdb	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	083216b5-3aca-4685-b461-e835aff2acd7
067fa576-a054-4918-8a40-f5cac42adaf3	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	083216b5-3aca-4685-b461-e835aff2acd7
0eb22390-5f41-49f6-b00a-be10e1e47d04	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	1b558ef7-32d7-4df6-af3f-25ca4089b195
907e6d25-73b8-4c60-9ab4-a3d70e5877f2	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	d7d2f37c-0430-498e-9f5f-91135e10d64e
d80eed42-0c80-484a-9e75-87523cb897c6	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	d7d2f37c-0430-498e-9f5f-91135e10d64e
96feb1bb-fc7b-404f-99a8-dc065aeff468	acr loa level	openid-connect	oidc-acr-mapper	\N	52c17ef6-dd48-457f-b27d-047c0bb84708
62edd484-d19a-43cf-b870-52d715c74857	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	02ceb4d8-fe1c-423a-903f-5e4fa5bd2d6d
f81dad1b-6c63-43d0-b114-2f93ede06608	sub	openid-connect	oidc-sub-mapper	\N	02ceb4d8-fe1c-423a-903f-5e4fa5bd2d6d
ab56a80a-71ad-4cb4-b69a-4fc04abd8eb5	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	\N	ac769c39-1b97-45b7-8d94-42982e123337
87ba44e5-f886-401c-a475-5d885a10fea6	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	\N	ac769c39-1b97-45b7-8d94-42982e123337
02d7702b-39e3-4bab-8d4c-57dd724ae241	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	\N	ac769c39-1b97-45b7-8d94-42982e123337
cf36c6d4-c06c-442e-ac70-ed2389312d46	organization	openid-connect	oidc-organization-membership-mapper	\N	d0179dba-d8ad-4d2a-9231-075f2e6530c8
34c9adf6-0835-4159-acf6-8517f678a830	audience resolve	openid-connect	oidc-audience-resolve-mapper	6594bd92-c078-437d-aa19-32810411fe71	\N
a32a1db1-71e2-40ed-82f5-47b13bc6de75	role list	saml	saml-role-list-mapper	\N	2977881a-44c7-40ba-aa11-afb0a05ec0b2
b7cdfe08-10e3-4826-a086-c3774c59ca61	organization	saml	saml-organization-membership-mapper	\N	8c468075-525e-4ab3-94ec-ba4dc437c24f
293b68fe-a088-464f-8670-dd211fd22480	full name	openid-connect	oidc-full-name-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
38a7f9db-01b8-415a-b6bf-70ae1c4eef65	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
00d212eb-01d5-46b6-b5d5-6508de293795	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
d9e2620b-5e17-4bec-b2d9-be8f21b464cb	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
de8ad1a5-2440-4f3d-b34b-a5006cf4ebec	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
a7773429-78c2-4927-a68c-acf262d05221	username	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
92c4861f-a91b-4498-99d6-975c61de6893	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
7b8aaffb-fd08-4676-8e3c-9e4831d00fb9	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
fd5b99a4-55b6-4e26-9db2-f0b921b5de71	website	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
fcd4f406-7ec0-4438-a9f7-055ecc2530ef	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
35e8889d-ea7a-4b47-8187-04e1262168aa	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
7fc105b8-8b25-4cb4-9cd0-214a89fd378a	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
395a99cd-b0f0-4cf2-ac8b-eb4807e0292d	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
fe33b2ef-1731-42cb-a052-6183b0a48317	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	178dac49-f258-4a20-a227-baca55f97d8d
d34a981d-b8e7-468b-857f-d171431008fa	email	openid-connect	oidc-usermodel-attribute-mapper	\N	b9c6ce23-7173-41dd-be46-cdfb74fec18a
4edd640a-954b-4b4d-8c2a-dc0735636f7b	email verified	openid-connect	oidc-usermodel-property-mapper	\N	b9c6ce23-7173-41dd-be46-cdfb74fec18a
b2514cf3-1e08-4a6c-874a-93c408c7cda3	address	openid-connect	oidc-address-mapper	\N	1ed0d4c4-0720-4e69-be21-091241d3c574
e77cb75e-8daa-41e0-94ad-960241c0e49c	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	49ab1a06-38f4-4c32-868e-48b61022c00f
110a70c7-23d4-4057-8b83-2889fa1d7de0	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	49ab1a06-38f4-4c32-868e-48b61022c00f
1aab1b6e-6475-4f3d-a583-ebab611ccb95	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	5b0a8700-85e8-46b9-a764-6cd2f85d8846
dffa3157-9066-460a-acde-6f76917eaf58	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	5b0a8700-85e8-46b9-a764-6cd2f85d8846
0476f038-5793-43e1-b2f5-ff73109f4acd	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	5b0a8700-85e8-46b9-a764-6cd2f85d8846
5a735885-7e15-446d-9f72-b272e6bb8523	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	ef14b883-04bf-4557-be1a-231b99162857
4584acc2-8518-460a-ac8e-98a0ce64da05	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	813c8c55-74e0-494f-9682-23d026340f42
dc996a1c-997b-41ab-9e5c-3ee8c562e45e	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	813c8c55-74e0-494f-9682-23d026340f42
3e7be768-fbdb-4b2a-8058-8af956a64b1c	acr loa level	openid-connect	oidc-acr-mapper	\N	fa609b0e-925f-4251-a437-291fdf9d71a1
7dd48cb9-01d0-4b51-b52b-1354faf6af82	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	51061315-4b70-49de-b605-55a40d6ab93f
ef392c07-0536-4744-a93a-292f8d4be30f	sub	openid-connect	oidc-sub-mapper	\N	51061315-4b70-49de-b605-55a40d6ab93f
bf732aa4-eab3-4e40-9a1f-1b9362f5efdb	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	\N	c6917b9d-3aae-48d7-887d-9d1f1c3c50a0
3d5a8744-6de1-4b33-971d-25b65085c6a6	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	\N	c6917b9d-3aae-48d7-887d-9d1f1c3c50a0
aa5e834b-ecbb-4370-920e-6e357f344b65	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	\N	c6917b9d-3aae-48d7-887d-9d1f1c3c50a0
7db30151-718b-4e8b-b427-ce7932454cdb	organization	openid-connect	oidc-organization-membership-mapper	\N	411c662c-cd97-4f46-a8bc-7a4f473f7cfb
244b6e81-075f-4cfa-b096-aa4684826425	client roles in id token	openid-connect	oidc-usermodel-client-role-mapper	4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	\N
bfe6ec87-fd46-4d4f-872c-3181f3a96bdd	locale	openid-connect	oidc-usermodel-attribute-mapper	b323fd36-7155-40a7-9eb1-94d315656e84	\N
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
8b2734a8-ef71-4b4c-8e19-f606aeed6bdd	true	introspection.token.claim
8b2734a8-ef71-4b4c-8e19-f606aeed6bdd	true	userinfo.token.claim
8b2734a8-ef71-4b4c-8e19-f606aeed6bdd	locale	user.attribute
8b2734a8-ef71-4b4c-8e19-f606aeed6bdd	true	id.token.claim
8b2734a8-ef71-4b4c-8e19-f606aeed6bdd	true	access.token.claim
8b2734a8-ef71-4b4c-8e19-f606aeed6bdd	locale	claim.name
8b2734a8-ef71-4b4c-8e19-f606aeed6bdd	String	jsonType.label
b6847ba9-baef-4927-9980-eb4f04719524	false	single
b6847ba9-baef-4927-9980-eb4f04719524	Basic	attribute.nameformat
b6847ba9-baef-4927-9980-eb4f04719524	Role	attribute.name
194b7405-0884-4637-8bb7-ae66af3015d5	true	introspection.token.claim
194b7405-0884-4637-8bb7-ae66af3015d5	true	userinfo.token.claim
194b7405-0884-4637-8bb7-ae66af3015d5	firstName	user.attribute
194b7405-0884-4637-8bb7-ae66af3015d5	true	id.token.claim
194b7405-0884-4637-8bb7-ae66af3015d5	true	access.token.claim
194b7405-0884-4637-8bb7-ae66af3015d5	given_name	claim.name
194b7405-0884-4637-8bb7-ae66af3015d5	String	jsonType.label
209b6b65-9ec5-409e-a906-254759c42e1f	true	introspection.token.claim
209b6b65-9ec5-409e-a906-254759c42e1f	true	userinfo.token.claim
209b6b65-9ec5-409e-a906-254759c42e1f	gender	user.attribute
209b6b65-9ec5-409e-a906-254759c42e1f	true	id.token.claim
209b6b65-9ec5-409e-a906-254759c42e1f	true	access.token.claim
209b6b65-9ec5-409e-a906-254759c42e1f	gender	claim.name
209b6b65-9ec5-409e-a906-254759c42e1f	String	jsonType.label
2535f545-1983-444c-9d4e-49f248788832	true	introspection.token.claim
2535f545-1983-444c-9d4e-49f248788832	true	userinfo.token.claim
2535f545-1983-444c-9d4e-49f248788832	updatedAt	user.attribute
2535f545-1983-444c-9d4e-49f248788832	true	id.token.claim
2535f545-1983-444c-9d4e-49f248788832	true	access.token.claim
2535f545-1983-444c-9d4e-49f248788832	updated_at	claim.name
2535f545-1983-444c-9d4e-49f248788832	long	jsonType.label
3bbbd110-ce51-4c04-939d-6d10f9de7033	true	introspection.token.claim
3bbbd110-ce51-4c04-939d-6d10f9de7033	true	userinfo.token.claim
3bbbd110-ce51-4c04-939d-6d10f9de7033	username	user.attribute
3bbbd110-ce51-4c04-939d-6d10f9de7033	true	id.token.claim
3bbbd110-ce51-4c04-939d-6d10f9de7033	true	access.token.claim
3bbbd110-ce51-4c04-939d-6d10f9de7033	preferred_username	claim.name
3bbbd110-ce51-4c04-939d-6d10f9de7033	String	jsonType.label
3cfe56a4-8d7e-46ec-b8bf-d1343dbc0289	true	introspection.token.claim
3cfe56a4-8d7e-46ec-b8bf-d1343dbc0289	true	userinfo.token.claim
3cfe56a4-8d7e-46ec-b8bf-d1343dbc0289	true	id.token.claim
3cfe56a4-8d7e-46ec-b8bf-d1343dbc0289	true	access.token.claim
403390d1-2f94-4328-8b24-5306ede5b7fc	true	introspection.token.claim
403390d1-2f94-4328-8b24-5306ede5b7fc	true	userinfo.token.claim
403390d1-2f94-4328-8b24-5306ede5b7fc	picture	user.attribute
403390d1-2f94-4328-8b24-5306ede5b7fc	true	id.token.claim
403390d1-2f94-4328-8b24-5306ede5b7fc	true	access.token.claim
403390d1-2f94-4328-8b24-5306ede5b7fc	picture	claim.name
403390d1-2f94-4328-8b24-5306ede5b7fc	String	jsonType.label
5c5cad44-ce80-49ac-98b0-bfb6ff4045fa	true	introspection.token.claim
5c5cad44-ce80-49ac-98b0-bfb6ff4045fa	true	userinfo.token.claim
5c5cad44-ce80-49ac-98b0-bfb6ff4045fa	middleName	user.attribute
5c5cad44-ce80-49ac-98b0-bfb6ff4045fa	true	id.token.claim
5c5cad44-ce80-49ac-98b0-bfb6ff4045fa	true	access.token.claim
5c5cad44-ce80-49ac-98b0-bfb6ff4045fa	middle_name	claim.name
5c5cad44-ce80-49ac-98b0-bfb6ff4045fa	String	jsonType.label
747b597d-a0cb-40a2-b742-0fa98c7fff6e	true	introspection.token.claim
747b597d-a0cb-40a2-b742-0fa98c7fff6e	true	userinfo.token.claim
747b597d-a0cb-40a2-b742-0fa98c7fff6e	profile	user.attribute
747b597d-a0cb-40a2-b742-0fa98c7fff6e	true	id.token.claim
747b597d-a0cb-40a2-b742-0fa98c7fff6e	true	access.token.claim
747b597d-a0cb-40a2-b742-0fa98c7fff6e	profile	claim.name
747b597d-a0cb-40a2-b742-0fa98c7fff6e	String	jsonType.label
8ba4e1fc-837b-4a36-9532-584174013244	true	introspection.token.claim
8ba4e1fc-837b-4a36-9532-584174013244	true	userinfo.token.claim
8ba4e1fc-837b-4a36-9532-584174013244	nickname	user.attribute
8ba4e1fc-837b-4a36-9532-584174013244	true	id.token.claim
8ba4e1fc-837b-4a36-9532-584174013244	true	access.token.claim
8ba4e1fc-837b-4a36-9532-584174013244	nickname	claim.name
8ba4e1fc-837b-4a36-9532-584174013244	String	jsonType.label
a1a2de6e-9fa7-4351-9881-f36bcafc0fa0	true	introspection.token.claim
a1a2de6e-9fa7-4351-9881-f36bcafc0fa0	true	userinfo.token.claim
a1a2de6e-9fa7-4351-9881-f36bcafc0fa0	birthdate	user.attribute
a1a2de6e-9fa7-4351-9881-f36bcafc0fa0	true	id.token.claim
a1a2de6e-9fa7-4351-9881-f36bcafc0fa0	true	access.token.claim
a1a2de6e-9fa7-4351-9881-f36bcafc0fa0	birthdate	claim.name
a1a2de6e-9fa7-4351-9881-f36bcafc0fa0	String	jsonType.label
ae8171b9-d14f-4f07-b914-9df970110126	true	introspection.token.claim
ae8171b9-d14f-4f07-b914-9df970110126	true	userinfo.token.claim
ae8171b9-d14f-4f07-b914-9df970110126	lastName	user.attribute
ae8171b9-d14f-4f07-b914-9df970110126	true	id.token.claim
ae8171b9-d14f-4f07-b914-9df970110126	true	access.token.claim
ae8171b9-d14f-4f07-b914-9df970110126	family_name	claim.name
ae8171b9-d14f-4f07-b914-9df970110126	String	jsonType.label
c0ff9053-29f2-48b7-8b7e-ae9efd7a0747	true	introspection.token.claim
c0ff9053-29f2-48b7-8b7e-ae9efd7a0747	true	userinfo.token.claim
c0ff9053-29f2-48b7-8b7e-ae9efd7a0747	zoneinfo	user.attribute
c0ff9053-29f2-48b7-8b7e-ae9efd7a0747	true	id.token.claim
c0ff9053-29f2-48b7-8b7e-ae9efd7a0747	true	access.token.claim
c0ff9053-29f2-48b7-8b7e-ae9efd7a0747	zoneinfo	claim.name
c0ff9053-29f2-48b7-8b7e-ae9efd7a0747	String	jsonType.label
e4c83ef5-9dd9-48de-ac68-2ec10ddaa52b	true	introspection.token.claim
e4c83ef5-9dd9-48de-ac68-2ec10ddaa52b	true	userinfo.token.claim
e4c83ef5-9dd9-48de-ac68-2ec10ddaa52b	locale	user.attribute
e4c83ef5-9dd9-48de-ac68-2ec10ddaa52b	true	id.token.claim
e4c83ef5-9dd9-48de-ac68-2ec10ddaa52b	true	access.token.claim
e4c83ef5-9dd9-48de-ac68-2ec10ddaa52b	locale	claim.name
e4c83ef5-9dd9-48de-ac68-2ec10ddaa52b	String	jsonType.label
feb11978-72fa-431d-9e4f-6db654011607	true	introspection.token.claim
feb11978-72fa-431d-9e4f-6db654011607	true	userinfo.token.claim
feb11978-72fa-431d-9e4f-6db654011607	website	user.attribute
feb11978-72fa-431d-9e4f-6db654011607	true	id.token.claim
feb11978-72fa-431d-9e4f-6db654011607	true	access.token.claim
feb11978-72fa-431d-9e4f-6db654011607	website	claim.name
feb11978-72fa-431d-9e4f-6db654011607	String	jsonType.label
94ed27a0-dbc7-4be3-b329-7ae3d1c5e716	true	introspection.token.claim
94ed27a0-dbc7-4be3-b329-7ae3d1c5e716	true	userinfo.token.claim
94ed27a0-dbc7-4be3-b329-7ae3d1c5e716	email	user.attribute
94ed27a0-dbc7-4be3-b329-7ae3d1c5e716	true	id.token.claim
94ed27a0-dbc7-4be3-b329-7ae3d1c5e716	true	access.token.claim
94ed27a0-dbc7-4be3-b329-7ae3d1c5e716	email	claim.name
94ed27a0-dbc7-4be3-b329-7ae3d1c5e716	String	jsonType.label
c22dce6f-6f97-4c95-8864-f55cd95c8df6	true	introspection.token.claim
c22dce6f-6f97-4c95-8864-f55cd95c8df6	true	userinfo.token.claim
c22dce6f-6f97-4c95-8864-f55cd95c8df6	emailVerified	user.attribute
c22dce6f-6f97-4c95-8864-f55cd95c8df6	true	id.token.claim
c22dce6f-6f97-4c95-8864-f55cd95c8df6	true	access.token.claim
c22dce6f-6f97-4c95-8864-f55cd95c8df6	email_verified	claim.name
c22dce6f-6f97-4c95-8864-f55cd95c8df6	boolean	jsonType.label
b1b8dec9-1e03-43fc-8055-f2b76e0fc5b2	formatted	user.attribute.formatted
b1b8dec9-1e03-43fc-8055-f2b76e0fc5b2	country	user.attribute.country
b1b8dec9-1e03-43fc-8055-f2b76e0fc5b2	true	introspection.token.claim
b1b8dec9-1e03-43fc-8055-f2b76e0fc5b2	postal_code	user.attribute.postal_code
b1b8dec9-1e03-43fc-8055-f2b76e0fc5b2	true	userinfo.token.claim
b1b8dec9-1e03-43fc-8055-f2b76e0fc5b2	street	user.attribute.street
b1b8dec9-1e03-43fc-8055-f2b76e0fc5b2	true	id.token.claim
b1b8dec9-1e03-43fc-8055-f2b76e0fc5b2	region	user.attribute.region
b1b8dec9-1e03-43fc-8055-f2b76e0fc5b2	true	access.token.claim
b1b8dec9-1e03-43fc-8055-f2b76e0fc5b2	locality	user.attribute.locality
07d34669-5cb9-4f88-be0f-7f33ea9ef8ef	true	introspection.token.claim
07d34669-5cb9-4f88-be0f-7f33ea9ef8ef	true	userinfo.token.claim
07d34669-5cb9-4f88-be0f-7f33ea9ef8ef	phoneNumberVerified	user.attribute
07d34669-5cb9-4f88-be0f-7f33ea9ef8ef	true	id.token.claim
07d34669-5cb9-4f88-be0f-7f33ea9ef8ef	true	access.token.claim
07d34669-5cb9-4f88-be0f-7f33ea9ef8ef	phone_number_verified	claim.name
07d34669-5cb9-4f88-be0f-7f33ea9ef8ef	boolean	jsonType.label
0d4c2dbf-2455-4471-8515-ab3698cbf8b0	true	introspection.token.claim
0d4c2dbf-2455-4471-8515-ab3698cbf8b0	true	userinfo.token.claim
0d4c2dbf-2455-4471-8515-ab3698cbf8b0	phoneNumber	user.attribute
0d4c2dbf-2455-4471-8515-ab3698cbf8b0	true	id.token.claim
0d4c2dbf-2455-4471-8515-ab3698cbf8b0	true	access.token.claim
0d4c2dbf-2455-4471-8515-ab3698cbf8b0	phone_number	claim.name
0d4c2dbf-2455-4471-8515-ab3698cbf8b0	String	jsonType.label
067fa576-a054-4918-8a40-f5cac42adaf3	true	introspection.token.claim
067fa576-a054-4918-8a40-f5cac42adaf3	true	access.token.claim
07117a4e-065d-426b-add2-86c321174fdb	true	introspection.token.claim
07117a4e-065d-426b-add2-86c321174fdb	true	multivalued
07117a4e-065d-426b-add2-86c321174fdb	foo	user.attribute
07117a4e-065d-426b-add2-86c321174fdb	true	access.token.claim
07117a4e-065d-426b-add2-86c321174fdb	resource_access.${client_id}.roles	claim.name
07117a4e-065d-426b-add2-86c321174fdb	String	jsonType.label
27c075ae-21ce-4983-b8ad-57fbc4e208c1	true	introspection.token.claim
27c075ae-21ce-4983-b8ad-57fbc4e208c1	true	multivalued
27c075ae-21ce-4983-b8ad-57fbc4e208c1	foo	user.attribute
27c075ae-21ce-4983-b8ad-57fbc4e208c1	true	access.token.claim
27c075ae-21ce-4983-b8ad-57fbc4e208c1	realm_access.roles	claim.name
27c075ae-21ce-4983-b8ad-57fbc4e208c1	String	jsonType.label
0eb22390-5f41-49f6-b00a-be10e1e47d04	true	introspection.token.claim
0eb22390-5f41-49f6-b00a-be10e1e47d04	true	access.token.claim
907e6d25-73b8-4c60-9ab4-a3d70e5877f2	true	introspection.token.claim
907e6d25-73b8-4c60-9ab4-a3d70e5877f2	true	userinfo.token.claim
907e6d25-73b8-4c60-9ab4-a3d70e5877f2	username	user.attribute
907e6d25-73b8-4c60-9ab4-a3d70e5877f2	true	id.token.claim
907e6d25-73b8-4c60-9ab4-a3d70e5877f2	true	access.token.claim
907e6d25-73b8-4c60-9ab4-a3d70e5877f2	upn	claim.name
907e6d25-73b8-4c60-9ab4-a3d70e5877f2	String	jsonType.label
d80eed42-0c80-484a-9e75-87523cb897c6	true	introspection.token.claim
d80eed42-0c80-484a-9e75-87523cb897c6	true	multivalued
d80eed42-0c80-484a-9e75-87523cb897c6	foo	user.attribute
d80eed42-0c80-484a-9e75-87523cb897c6	true	id.token.claim
d80eed42-0c80-484a-9e75-87523cb897c6	true	access.token.claim
d80eed42-0c80-484a-9e75-87523cb897c6	groups	claim.name
d80eed42-0c80-484a-9e75-87523cb897c6	String	jsonType.label
96feb1bb-fc7b-404f-99a8-dc065aeff468	true	introspection.token.claim
96feb1bb-fc7b-404f-99a8-dc065aeff468	true	id.token.claim
96feb1bb-fc7b-404f-99a8-dc065aeff468	true	access.token.claim
62edd484-d19a-43cf-b870-52d715c74857	AUTH_TIME	user.session.note
62edd484-d19a-43cf-b870-52d715c74857	true	introspection.token.claim
62edd484-d19a-43cf-b870-52d715c74857	true	id.token.claim
62edd484-d19a-43cf-b870-52d715c74857	true	access.token.claim
62edd484-d19a-43cf-b870-52d715c74857	auth_time	claim.name
62edd484-d19a-43cf-b870-52d715c74857	long	jsonType.label
f81dad1b-6c63-43d0-b114-2f93ede06608	true	introspection.token.claim
f81dad1b-6c63-43d0-b114-2f93ede06608	true	access.token.claim
02d7702b-39e3-4bab-8d4c-57dd724ae241	clientAddress	user.session.note
02d7702b-39e3-4bab-8d4c-57dd724ae241	true	introspection.token.claim
02d7702b-39e3-4bab-8d4c-57dd724ae241	true	id.token.claim
02d7702b-39e3-4bab-8d4c-57dd724ae241	true	access.token.claim
02d7702b-39e3-4bab-8d4c-57dd724ae241	clientAddress	claim.name
02d7702b-39e3-4bab-8d4c-57dd724ae241	String	jsonType.label
87ba44e5-f886-401c-a475-5d885a10fea6	clientHost	user.session.note
87ba44e5-f886-401c-a475-5d885a10fea6	true	introspection.token.claim
87ba44e5-f886-401c-a475-5d885a10fea6	true	id.token.claim
87ba44e5-f886-401c-a475-5d885a10fea6	true	access.token.claim
87ba44e5-f886-401c-a475-5d885a10fea6	clientHost	claim.name
87ba44e5-f886-401c-a475-5d885a10fea6	String	jsonType.label
ab56a80a-71ad-4cb4-b69a-4fc04abd8eb5	client_id	user.session.note
ab56a80a-71ad-4cb4-b69a-4fc04abd8eb5	true	introspection.token.claim
ab56a80a-71ad-4cb4-b69a-4fc04abd8eb5	true	id.token.claim
ab56a80a-71ad-4cb4-b69a-4fc04abd8eb5	true	access.token.claim
ab56a80a-71ad-4cb4-b69a-4fc04abd8eb5	client_id	claim.name
ab56a80a-71ad-4cb4-b69a-4fc04abd8eb5	String	jsonType.label
cf36c6d4-c06c-442e-ac70-ed2389312d46	true	introspection.token.claim
cf36c6d4-c06c-442e-ac70-ed2389312d46	true	multivalued
cf36c6d4-c06c-442e-ac70-ed2389312d46	true	id.token.claim
cf36c6d4-c06c-442e-ac70-ed2389312d46	true	access.token.claim
cf36c6d4-c06c-442e-ac70-ed2389312d46	organization	claim.name
cf36c6d4-c06c-442e-ac70-ed2389312d46	String	jsonType.label
a32a1db1-71e2-40ed-82f5-47b13bc6de75	false	single
a32a1db1-71e2-40ed-82f5-47b13bc6de75	Basic	attribute.nameformat
a32a1db1-71e2-40ed-82f5-47b13bc6de75	Role	attribute.name
00d212eb-01d5-46b6-b5d5-6508de293795	true	introspection.token.claim
00d212eb-01d5-46b6-b5d5-6508de293795	true	userinfo.token.claim
00d212eb-01d5-46b6-b5d5-6508de293795	firstName	user.attribute
00d212eb-01d5-46b6-b5d5-6508de293795	true	id.token.claim
00d212eb-01d5-46b6-b5d5-6508de293795	true	access.token.claim
00d212eb-01d5-46b6-b5d5-6508de293795	given_name	claim.name
00d212eb-01d5-46b6-b5d5-6508de293795	String	jsonType.label
293b68fe-a088-464f-8670-dd211fd22480	true	introspection.token.claim
293b68fe-a088-464f-8670-dd211fd22480	true	userinfo.token.claim
293b68fe-a088-464f-8670-dd211fd22480	true	id.token.claim
293b68fe-a088-464f-8670-dd211fd22480	true	access.token.claim
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
0476f038-5793-43e1-b2f5-ff73109f4acd	true	introspection.token.claim
0476f038-5793-43e1-b2f5-ff73109f4acd	true	access.token.claim
1aab1b6e-6475-4f3d-a583-ebab611ccb95	true	introspection.token.claim
1aab1b6e-6475-4f3d-a583-ebab611ccb95	true	multivalued
1aab1b6e-6475-4f3d-a583-ebab611ccb95	foo	user.attribute
1aab1b6e-6475-4f3d-a583-ebab611ccb95	true	access.token.claim
1aab1b6e-6475-4f3d-a583-ebab611ccb95	realm_access.roles	claim.name
1aab1b6e-6475-4f3d-a583-ebab611ccb95	String	jsonType.label
dffa3157-9066-460a-acde-6f76917eaf58	true	introspection.token.claim
dffa3157-9066-460a-acde-6f76917eaf58	true	multivalued
dffa3157-9066-460a-acde-6f76917eaf58	foo	user.attribute
dffa3157-9066-460a-acde-6f76917eaf58	true	access.token.claim
dffa3157-9066-460a-acde-6f76917eaf58	resource_access.${client_id}.roles	claim.name
dffa3157-9066-460a-acde-6f76917eaf58	String	jsonType.label
5a735885-7e15-446d-9f72-b272e6bb8523	true	introspection.token.claim
5a735885-7e15-446d-9f72-b272e6bb8523	true	access.token.claim
4584acc2-8518-460a-ac8e-98a0ce64da05	true	introspection.token.claim
4584acc2-8518-460a-ac8e-98a0ce64da05	true	userinfo.token.claim
4584acc2-8518-460a-ac8e-98a0ce64da05	username	user.attribute
4584acc2-8518-460a-ac8e-98a0ce64da05	true	id.token.claim
4584acc2-8518-460a-ac8e-98a0ce64da05	true	access.token.claim
4584acc2-8518-460a-ac8e-98a0ce64da05	upn	claim.name
4584acc2-8518-460a-ac8e-98a0ce64da05	String	jsonType.label
dc996a1c-997b-41ab-9e5c-3ee8c562e45e	true	introspection.token.claim
dc996a1c-997b-41ab-9e5c-3ee8c562e45e	true	multivalued
dc996a1c-997b-41ab-9e5c-3ee8c562e45e	foo	user.attribute
dc996a1c-997b-41ab-9e5c-3ee8c562e45e	true	id.token.claim
dc996a1c-997b-41ab-9e5c-3ee8c562e45e	true	access.token.claim
dc996a1c-997b-41ab-9e5c-3ee8c562e45e	groups	claim.name
dc996a1c-997b-41ab-9e5c-3ee8c562e45e	String	jsonType.label
3e7be768-fbdb-4b2a-8058-8af956a64b1c	true	introspection.token.claim
3e7be768-fbdb-4b2a-8058-8af956a64b1c	true	id.token.claim
3e7be768-fbdb-4b2a-8058-8af956a64b1c	true	access.token.claim
7dd48cb9-01d0-4b51-b52b-1354faf6af82	AUTH_TIME	user.session.note
7dd48cb9-01d0-4b51-b52b-1354faf6af82	true	introspection.token.claim
7dd48cb9-01d0-4b51-b52b-1354faf6af82	true	id.token.claim
7dd48cb9-01d0-4b51-b52b-1354faf6af82	true	access.token.claim
7dd48cb9-01d0-4b51-b52b-1354faf6af82	auth_time	claim.name
7dd48cb9-01d0-4b51-b52b-1354faf6af82	long	jsonType.label
ef392c07-0536-4744-a93a-292f8d4be30f	true	introspection.token.claim
ef392c07-0536-4744-a93a-292f8d4be30f	true	access.token.claim
3d5a8744-6de1-4b33-971d-25b65085c6a6	clientHost	user.session.note
3d5a8744-6de1-4b33-971d-25b65085c6a6	true	introspection.token.claim
3d5a8744-6de1-4b33-971d-25b65085c6a6	true	id.token.claim
3d5a8744-6de1-4b33-971d-25b65085c6a6	true	access.token.claim
3d5a8744-6de1-4b33-971d-25b65085c6a6	clientHost	claim.name
3d5a8744-6de1-4b33-971d-25b65085c6a6	String	jsonType.label
aa5e834b-ecbb-4370-920e-6e357f344b65	clientAddress	user.session.note
aa5e834b-ecbb-4370-920e-6e357f344b65	true	introspection.token.claim
aa5e834b-ecbb-4370-920e-6e357f344b65	true	id.token.claim
aa5e834b-ecbb-4370-920e-6e357f344b65	true	access.token.claim
aa5e834b-ecbb-4370-920e-6e357f344b65	clientAddress	claim.name
aa5e834b-ecbb-4370-920e-6e357f344b65	String	jsonType.label
bf732aa4-eab3-4e40-9a1f-1b9362f5efdb	client_id	user.session.note
bf732aa4-eab3-4e40-9a1f-1b9362f5efdb	true	introspection.token.claim
bf732aa4-eab3-4e40-9a1f-1b9362f5efdb	true	id.token.claim
bf732aa4-eab3-4e40-9a1f-1b9362f5efdb	true	access.token.claim
bf732aa4-eab3-4e40-9a1f-1b9362f5efdb	client_id	claim.name
bf732aa4-eab3-4e40-9a1f-1b9362f5efdb	String	jsonType.label
7db30151-718b-4e8b-b427-ce7932454cdb	true	introspection.token.claim
7db30151-718b-4e8b-b427-ce7932454cdb	true	multivalued
7db30151-718b-4e8b-b427-ce7932454cdb	true	id.token.claim
7db30151-718b-4e8b-b427-ce7932454cdb	true	access.token.claim
7db30151-718b-4e8b-b427-ce7932454cdb	organization	claim.name
7db30151-718b-4e8b-b427-ce7932454cdb	String	jsonType.label
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
5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	60	300	300	\N	\N	\N	t	f	0	\N	nextjs-dashboard	0	\N	t	f	t	f	EXTERNAL	1800	36000	f	t	20a6e660-7f69-4043-a157-2d2f03b71f01	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	11d4a136-08ef-4185-879e-20a7e5e71ea0	58806ca6-b5ca-4f7f-9550-a8cec9066c73	8de5f3d7-1fd9-4859-97bb-5859d47db91c	1c24920f-adcf-403f-aeee-622e2218c632	f7ba0e0f-7be0-458e-aae1-6e59a6b35aec	2592000	f	900	t	f	478c5259-862d-4db9-a2ea-bd0887d86ee9	0	f	0	0	32d78998-b4a3-4358-9f41-9fb89659de0b
9427ab20-f0da-41bd-8ffd-6c4fffb2afec	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	2a3d7fb9-dc93-46c4-bf45-f40aca9d2e7c	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	4a846dc6-2f5a-4511-be8b-7cb3b102b7b2	b60df5bb-0405-4efb-bb7c-039a76420cbf	bd4dfd9f-d75d-43ac-9c9f-a1d0f788dabf	9718049a-8296-4ce6-a2ef-fd27474a8ff6	a6d113ef-e81f-42ac-b1a1-18bf9f7883f8	2592000	f	900	t	f	93510552-7da0-4d2f-8103-888e1c4267ac	0	f	0	0	3a60f580-118b-4313-9862-5e2ea6468ae3
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	
_browser_header.xContentTypeOptions	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	nosniff
_browser_header.referrerPolicy	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	no-referrer
_browser_header.xRobotsTag	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	none
_browser_header.xFrameOptions	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	SAMEORIGIN
_browser_header.contentSecurityPolicy	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.strictTransportSecurity	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	max-age=31536000; includeSubDomains
bruteForceProtected	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	false
permanentLockout	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	false
maxTemporaryLockouts	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	0
bruteForceStrategy	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	MULTIPLE
maxFailureWaitSeconds	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	900
minimumQuickLoginWaitSeconds	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	60
waitIncrementSeconds	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	60
quickLoginCheckMilliSeconds	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	1000
maxDeltaTimeSeconds	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	43200
failureFactor	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	30
realmReusableOtpCode	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	false
firstBrokerLoginFlowId	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	b52bd267-b851-43a1-8a88-7fa0693f0e0c
displayName	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	Keycloak
displayNameHtml	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	RS256
offlineSessionMaxLifespanEnabled	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	false
offlineSessionMaxLifespan	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	5184000
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
actionTokenGeneratedByAdminLifespan	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	43200
actionTokenGeneratedByUserLifespan	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	300
oauth2DeviceCodeLifespan	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	600
oauth2DevicePollingInterval	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	5
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
organizationsEnabled	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	false
adminPermissionsEnabled	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	false
verifiableCredentialsEnabled	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	false
clientSessionIdleTimeout	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	0
clientSessionMaxLifespan	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	0
clientOfflineSessionIdleTimeout	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	0
clientOfflineSessionMaxLifespan	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	0
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
9427ab20-f0da-41bd-8ffd-6c4fffb2afec	jboss-logging
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
password	password	t	t	9427ab20-f0da-41bd-8ffd-6c4fffb2afec
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
ac19a97d-4491-41af-821a-8ed32e659238	/realms/master/account/*
d71f7760-85bc-44da-bf2b-7f44d17e580b	/realms/master/account/*
bd065e4a-130c-45f2-8c11-674e99fb51fb	/admin/master/console/*
010b7dfa-bbb4-46d4-b0c8-2a7995d5bfa7	/realms/nextjs-dashboard/account/*
6594bd92-c078-437d-aa19-32810411fe71	/realms/nextjs-dashboard/account/*
b323fd36-7155-40a7-9eb1-94d315656e84	/admin/nextjs-dashboard/console/*
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	http://localhost:3000/*
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
f1fd5cbd-8aa1-4850-ba67-00735e65523c	VERIFY_EMAIL	Verify Email	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	t	f	VERIFY_EMAIL	50
e1a40061-9616-45ba-ae56-c9d533ac7928	UPDATE_PROFILE	Update Profile	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	t	f	UPDATE_PROFILE	40
3a08f25b-3540-4129-9a1d-c897aa2914b7	CONFIGURE_TOTP	Configure OTP	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	t	f	CONFIGURE_TOTP	10
cb09babf-8755-42c7-854a-83372d1882f1	UPDATE_PASSWORD	Update Password	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	t	f	UPDATE_PASSWORD	30
5434e6af-f42a-480b-ab28-76fa8351e710	TERMS_AND_CONDITIONS	Terms and Conditions	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	f	f	TERMS_AND_CONDITIONS	20
289e20fa-ec1d-4c8c-b599-91fd34532459	delete_account	Delete Account	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	f	f	delete_account	60
cce3ba18-fe66-4e01-b254-517ead4bcbff	delete_credential	Delete Credential	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	t	f	delete_credential	100
c84e9112-572e-42e4-894f-527cbc723911	update_user_locale	Update User Locale	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	t	f	update_user_locale	1000
1b860ca4-aaab-4638-aa1e-7776f2ad55d9	webauthn-register	Webauthn Register	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	t	f	webauthn-register	70
9405268d-8415-4535-b689-2e67be14e33a	webauthn-register-passwordless	Webauthn Register Passwordless	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	t	f	webauthn-register-passwordless	80
668430fa-ed15-40e7-9cf3-7272a3a90191	VERIFY_PROFILE	Verify Profile	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	t	f	VERIFY_PROFILE	90
43f3bcaf-e94b-4b81-8256-99e5628ddba6	VERIFY_EMAIL	Verify Email	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	t	f	VERIFY_EMAIL	50
dd46e219-b214-45f4-b712-84343b60923c	UPDATE_PROFILE	Update Profile	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	t	f	UPDATE_PROFILE	40
f3dafdb4-e73d-4e68-a0f5-90ffbd63177c	CONFIGURE_TOTP	Configure OTP	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	t	f	CONFIGURE_TOTP	10
43722884-0993-4fab-b17d-6dcc6460737d	UPDATE_PASSWORD	Update Password	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	t	f	UPDATE_PASSWORD	30
ba2631bf-fa3b-48c0-93f4-6bb4b0845662	TERMS_AND_CONDITIONS	Terms and Conditions	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	f	f	TERMS_AND_CONDITIONS	20
a80449a5-659a-4a38-a0e4-d0abdf50695a	delete_account	Delete Account	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	f	f	delete_account	60
52997b44-f962-4e17-a9fb-dcfac80625cc	delete_credential	Delete Credential	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	t	f	delete_credential	100
7feb112f-8ca5-40f6-a02d-6a0b3d6b3a10	update_user_locale	Update User Locale	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	t	f	update_user_locale	1000
95f88d61-53bd-4ef6-a24c-1ca83659f51a	webauthn-register	Webauthn Register	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	t	f	webauthn-register	70
355114c9-2f50-4fdc-96dd-9b1843721a20	webauthn-register-passwordless	Webauthn Register Passwordless	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	t	f	webauthn-register-passwordless	80
080a6942-b186-4ae6-a9eb-165930b56841	VERIFY_PROFILE	Verify Profile	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	t	f	VERIFY_PROFILE	90
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
d71f7760-85bc-44da-bf2b-7f44d17e580b	79b64669-e2f1-4bf3-a880-23403d52a92c
d71f7760-85bc-44da-bf2b-7f44d17e580b	d064310e-a85d-4180-a449-fb2b57cd41d3
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
is_temporary_admin	true	9849c786-ce3e-40db-8322-5c53c3d80651	b92a31d9-bf79-4c4a-afe7-687688cf6dfc	\N	\N	\N
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
e4d137a8-ca21-4bd5-80dc-69cee3432bdb	admin@parkigo.be	admin@parkigo.be	t	t	\N	Admin	ParkiGo	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	admin	\N	\N	0
ecacf8de-e81a-4ca7-83d6-d7fc200bf9a4	owner@parkigo.be	owner@parkigo.be	t	t	\N	Owner	ParkiGo	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	owner	\N	\N	0
15d36145-5cea-49e5-9f9f-fe71bfe502fb	renter@parkigo.be	renter@parkigo.be	t	t	\N	Renter	ParkiGo	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	renter	\N	\N	0
9849c786-ce3e-40db-8322-5c53c3d80651	\N	503d033a-8fc9-4579-8073-50168b582279	f	t	\N	\N	\N	9427ab20-f0da-41bd-8ffd-6c4fffb2afec	admin	1750781735165	\N	0
b1c7bfb6-8279-42c6-8cd5-2ac227717fb1	delvauxo@outlook.com	delvauxo@outlook.com	t	t	\N	Olivier	Delvaux	5f4a9fac-7a54-4799-a8f6-1c6dc80babfc	delvauxo	1750959726388	\N	0
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
38a16972-2598-4dd5-b2de-5a108ce9c748	e4d137a8-ca21-4bd5-80dc-69cee3432bdb
1fbe4fc6-50aa-45e4-adbf-f7b73d0e1836	ecacf8de-e81a-4ca7-83d6-d7fc200bf9a4
f509302a-4f0d-488f-ac8e-3b2858c5de9f	15d36145-5cea-49e5-9f9f-fe71bfe502fb
3a60f580-118b-4313-9862-5e2ea6468ae3	9849c786-ce3e-40db-8322-5c53c3d80651
e4bc0604-3995-4e2f-a040-0f0a87d89eef	9849c786-ce3e-40db-8322-5c53c3d80651
32d78998-b4a3-4358-9f41-9fb89659de0b	b1c7bfb6-8279-42c6-8cd5-2ac227717fb1
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: delvauxo
--

COPY public.web_origins (client_id, value) FROM stdin;
bd065e4a-130c-45f2-8c11-674e99fb51fb	+
b323fd36-7155-40a7-9eb1-94d315656e84	+
4f3a4304-78e2-4cc9-abbc-fe777a4a24ed	http://localhost:3000
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

