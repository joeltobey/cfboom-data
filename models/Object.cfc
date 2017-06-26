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
 * Objects represent database tables that contain your information.
 */
component
    extends="cfboom.lang.Object"
    displayname="Class Object"
    accessors="true"
    output="false"
{
    /**
     * Validation constraints using the cbvalidation module.
     */
    property name="constraints " type="struct" required="false";

    /**
     * Indicates whether the object can be created via the create() call (true) or not (false).
     */
    property name="createable" type="boolean" default="true";

    /**
     * Indicates whether the object can be deleted via the delete() call (true) or not (false).
     */
    property name="deletable" type="boolean" default="true";

    /**
     * Array of field names associated with the object in order.
     */
    property name="fields" type="array";

    /**
     * Map of cfboom.jdbc.models.Field objects.
     */
    property name="fieldMap" type="struct";

    /**
     * Label text for the object name.
     */
    property name="label" type="string" required="false";

    /**
     * Label text for an object that represents the plural version of an object name, for example, "Users."
     */
    property name="labelPlural" type="string" required="false";

    /**
     * Name of the object. Example: getInstance( name )
     */
    property name="name" type="string" required="true";

    /**
     * Name of the database table.
     */
    property name="table" type="string" required="true";

    /**
     * Indicates whether the object can be queried via the query() call (true) or not (false).
     */
    property name="queryable" type="boolean" default="true";

    /**
     * Indicates whether the object can be retrieved via the retrieve() call (true) or not (false).
     */
    property name="retrieveable" type="boolean" default="true";

    /**
     * Schema where the object is located.
     */
    property name="schema" type="string" required="false";

    /**
     * Indicates whether an object can be undeleted using the undelete() call (true) or not (false).
     */
    property name="undeletable" type="boolean" default="false";

    /**
     * Indicates whether the object can be updated via the update() call (true) or not (false).
     */
    property name="updateable" type="boolean" default="true";

    public cfboom.jdbc.models.Object function init() {
        return this;
    }
}
