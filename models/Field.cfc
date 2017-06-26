/*
 * Copyright 2017 Joel Tobey <joeltobey@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Fields on objects represent the details of each object and are analogous to columns in a database table.
 */
component
    extends="cfboom.lang.Object"
    displayname="Class Field"
    accessors="true"
    output="false"
{
    /**
     * Indicates whether the field is a custom formula field (true) or not (false). Note that custom formula fields are always read-only.
     */
    property name="calculated" type="boolean" default="false";

    /**
     * Indicates whether the field is case sensitive (true) or not (false).
     */
    property name="caseSensitive" type="boolean" default="false";

    /**
     * Indicates whether the field can be created (true) or not (false). If true, then this field value can be set in a create() call.
     */
    property name="createable" type="boolean" default="true";

    /**
     * Indicates whether this field is defaulted when created (true) or not (false). If true, the default value is implicitly assigns a value for this field when the object is created, even if a value for this field is not passed in on the create() call.
     */
    property name="defaultedOnCreate" type="boolean" default="true";

    /**
     * The default value specified for this field if the formula is not used. If no value has been specified, this field is not returned.
     */
    property name="defaultValueFormula" type="string" required="false";

    /**
     * For fields of type integer. Maximum number of digits. The API returns an error if an integer value exceeds the number of digits.
     */
    property name="digits" type="numeric" numeric="int" required="false";

    /**
     * Should be "id" for primary key. If fieldtype is not specified and the useDBForMapping=true, then the fieldtype is determined by inspecting the database.
     */
    property name="fieldType" type="string" required="false" validate="regex" validateparams="{pattern=collection|column|id|many-to-many|many-to-one|one-to-many|one-to-one|timestamp|version|none}";

    /**
     * Indicates whether the field is filterable (true) or not (false). If true, then this field can be specified in the WHERE clause of a query string in a query() call.
     */
    property name="filterable" type="boolean" default="true";

    /**
     * The formula specified for this field. If no formula is specified for this field, it is not returned.
     */
    property name="formula" type="string" required="false";

    /**
     * Indicates whether the field can be included in the GROUP BY clause of a SQL query (true) or not (false).
     */
    property name="groupable" type="boolean" default="true";

    /**
     * Label text for the field name.
     */
    property name="label" type="string" required="false";

    /**
     * For string fields, the maximum size of the field in Unicode characters (not bytes).
     */
    property name="length" type="numeric" numeric="int" required="false";

    /**
     * Field name used in API calls, such as create(), delete(), and query().
     */
    property name="name" type="string" required="true";

    /**
     * Database column name for the field.
     */
    property name="column" type="string" required="true";

    /**
     * Indicates whether the field is nillable (true) or not (false). A nillable field can have empty content. A non-nillable field must have a value in order for the object to be created or saved.
     */
    property name="nillable" type="boolean" default="true";

    /**
     * For fields of type double. Maximum number of digits that can be stored, including all numbers to the left and to the right of the decimal point (but excluding the decimal point character).
     */
    property name="precision" type="numeric" numeric="int" required="false";

    /**
     * For fields of type double. Number of digits to the right of the decimal point. The API silently truncates any extra digits to the right of the decimal point, but it returns a fault response if the number has too many digits to the left of the decimal point.
     */
    property name="scale" type="numeric" numeric="int" required="false";

    /**
     * Indicates whether a query can sort on this field (true) or not (false).
     */
    property name="sortable" type="boolean" default="true";

    /**
     * The queryParam cfsqltype value
     */
    property name="sqlType" type="string" required="true";

    /**
     * The data type as defined in the source database.
     */
    property name="type" type="string" required="true";

    /**
     * Indicates whether the value must be unique true) or not false).
     */
    property name="unique" type="boolean" default="false";

    /**
     * Indicates whether this field value can be updated via the update() call (true) or not (false).
     */
    property name="updateable" type="boolean" default="true";

    public cfboom.jdbc.models.Field function init() {
        return this;
    }
}
